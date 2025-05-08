import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/src/util/conditional_parent_widget.dart';

class OverlayAnchor extends StatefulWidget {
  final Alignment alignment;
  final bool anchor;
  final Widget Function() anchorBuilder;
  final bool avoidOverlap;

  final OverlayAnchorController? controller;

  /// Determines if the position is flexible or absolute when [keepInBounds] is
  /// true.
  ///
  /// If false, the position will always be placed based with respect to the
  /// [alignment] that has the most space. If flexible, then the position can
  /// be between absolute positions.
  final bool flexiblePosition;

  final double? height;

  /// Adjusts the position of the overlay if overflow is detected.
  ///
  final bool keepInBounds;

  final double? maxHeight;
  final double? maxWidth;
  final double? minHeight;
  final double? minWidth;

  final Offset? offset;

  final void Function(PointerDownEvent)? onTapOutside;

  final Widget Function(BuildContext) overlayBuilder;

  final double? width;

  const OverlayAnchor({
    super.key,
    this.alignment = Alignment.bottomCenter,
    this.anchor = true,
    required this.anchorBuilder,
    this.avoidOverlap = false,
    required this.controller,
    this.flexiblePosition = false,
    this.height,
    this.keepInBounds = true,
    this.maxHeight,
    this.maxWidth,
    this.minHeight,
    this.minWidth,
    this.offset,
    this.onTapOutside,
    required this.overlayBuilder,
    this.width,
  });

  @override
  State<OverlayAnchor> createState() => _OverlayAnchorState();
}

class _OverlayAnchorState extends State<OverlayAnchor>
    with SingleTickerProviderStateMixin {
  late final OverlayAnchorController _controller;
  final GlobalKey _anchorKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  late AnimationController _animationController;
  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? OverlayAnchorController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _controller._anchor = this;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _entry?.dispose();
    super.dispose();
  }

  void _openOverlay() async {
    if (_entry?.mounted ?? false) {
      return;
    }
    _entry = _buildOverlay();
    Overlay.of(context).insert(_entry!);
    _animationController.forward();
  }

  void _removeOverlay() async {
    await _animationController.reverse();
    if (_entry?.mounted ?? false) {
      _entry?.remove();
    }
  }

  OverlayEntry _buildOverlay() {
    return OverlayEntry(
      builder: (ctx) {
        return OverlayAnchorEntry(
          alignment: widget.alignment,
          anchor: widget.anchor,
          anchorKey: _anchorKey,
          animationController: _animationController,
          keepInBounds: widget.keepInBounds,
          layerLink: _layerLink,
          minHeight: widget.minHeight,
          offset: widget.offset,
          height: widget.height,
          onTapOutside: widget.onTapOutside,
          width: widget.width,
          child: widget.overlayBuilder(ctx),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      key: _anchorKey,
      link: _layerLink,
      child: widget.anchorBuilder(),
    );
  }
}

class OverlayAnchorEntry extends StatefulWidget {
  final Alignment alignment;
  final bool anchor;
  final GlobalKey anchorKey;
  final AnimationController animationController;
  final bool avoidOverlap;
  final Widget child;
  final bool flexiblePosition;
  final double? height;
  final bool keepInBounds;
  final LayerLink layerLink;
  final double? maxHeight;
  final double? maxWidth;
  final double? minHeight;
  final double? minWidth;
  final Offset? offset;
  final void Function(PointerDownEvent)? onTapOutside;

  /// If true, the height of the SizedBox around the child widget will be null.
  /// The height of the overlay will rely on the height of the child. No default
  /// height will be calculated. Cannot be used with `minHeight`, `height`, or
  /// `maxHeight`.
  final bool sizeXToChild;
  final double? width;

  OverlayAnchorEntry({
    super.key,
    this.alignment = Alignment.bottomCenter,
    this.anchor = true,
    required this.anchorKey,
    required this.animationController,
    this.avoidOverlap = true,
    required this.child,
    this.flexiblePosition = true,
    this.height,
    this.keepInBounds = true,
    required this.layerLink,
    this.maxHeight,
    this.maxWidth,
    this.minHeight,
    this.minWidth,
    this.offset,
    this.onTapOutside,
    this.sizeXToChild = false,
    this.width,
  }) {
    assert(sizeXToChild == false || keepInBounds == false,
        'Cannot size to child when keepInBounds is true.');

    // assert(_assertKeepInBounds(),
    //     'Must provide height or minHeight and width or minWidth when keepInBounds is true');
  }

  // bool _assertKeepInBounds() {
  //   if (keepInBounds) {
  //     // return (height != null || minHeight != null) &&
  //     //     (width != null || minWidth != null);
  //     return (height != null || minHeight != null);
  //   }
  //   return true;
  // }

  @override
  State<OverlayAnchorEntry> createState() => _OverlayAnchorEntryState();
}

class _OverlayAnchorEntryState extends State<OverlayAnchorEntry> {
  Rect? getAnchorRect() {
    final BuildContext? keyContext = widget.anchorKey.currentContext;

    if (keyContext != null) {
      final RenderBox anchorBox = keyContext.findRenderObject()! as RenderBox;
      final Size boxSize = anchorBox.size;
      final Offset boxLocation = anchorBox.localToGlobal(Offset.zero);
      return boxLocation & boxSize;
    }
    return null;
  }

  double _getXOffset(
    double xAlign,
    Rect? anchorRect,
    Size screenSize,
    double width,
  ) {
    double xOffset;

    xOffset = xAlign == -1
        ? 0
        : xAlign == 0
            ? screenSize.width / 2
            : screenSize.width - width;

    if (anchorRect != null) {
      xOffset = xAlign == -1.0
          ? -width
          : xAlign == 0.0
              ? anchorRect.width / 2 - (width / 2)
              : anchorRect.width;
    }

    // return offset != null ? offset!.dx + xOffset : xOffset;
    return xOffset;
  }

  double _getYOffset(
    double yAlign,
    Rect? anchorRect,
    double height,
    Size screenSize,
  ) {
    double yOffset;

    yOffset = yAlign == -1
        ? 0
        : yAlign == 0
            ? screenSize.height / 2
            : screenSize.height - height;

    if (anchorRect != null) {
      yOffset = yAlign == -1.0
          ? -height
          : yAlign == 0.0
              ? (anchorRect.height / 2) - (height / 2)
              : anchorRect.height;
    }

    // return offset != null ? offset!.dy + yOffset : yOffset;
    return yOffset;
  }

  double _getXPosition(double xAlign, Rect? anchorRect, double width) {
    if (anchorRect == null) return 0;

    return xAlign == -1
        ? anchorRect.left - width
        : xAlign == 0
            ? anchorRect.center.dx - width / 2
            : anchorRect.right;
  }

  double _getYPosition(double yAlign, Rect? anchorRect, double height) {
    if (anchorRect == null) return 0;

    return yAlign == -1
        ? anchorRect.top - height
        : yAlign == 0
            ? anchorRect.center.dy - height / 2
            : anchorRect.bottom;
  }

  _OverlayRect _getOverlayRect(
    Alignment alignment,
    Rect? anchorRect,
    double height,
    double width,
  ) {
    double yPosition = _getYPosition(alignment.y, anchorRect, height);
    double xPosition = _getXPosition(alignment.x, anchorRect, width);

    return _OverlayRect.fromLTWH(
      alignment: alignment,
      combinedOverflowSum: 0,
      left: xPosition,
      top: yPosition,
      width: width,
      height: height,
    );
  }

  /// A sum of the left and right overflow - can be negative.
  double _getXOverflowSum(Rect rect, Size screenSize) {
    double overflow = 0;

    if (rect.left < 0) {
      overflow += (0 - rect.left);
    }
    if (rect.right > screenSize.width) {
      overflow += rect.right - screenSize.width;
    }
    return overflow;
  }

  /// A sum of the bottom and top overflow - can be negative.
  double _getYOverflowSum(Rect rect, Size screenSize) {
    double overflow = 0;

    if (rect.top < 0) {
      overflow += rect.top;
    }
    if (rect.bottom > screenSize.height) {
      overflow += (rect.bottom - screenSize.height);
    }
    return overflow;
  }

  double _getCombinedAbsoluteOverflowSum(Rect rect, Size screenSize) {
    double x = _getXOverflowSum(rect, screenSize).abs();
    double y = _getYOverflowSum(rect, screenSize).abs();
    return x + y;
  }

  List<_OverlayRect> _getFlexibleRects(
    Rect anchorRect,
    double height,
    double width,
    double xOverflow,
    double yOverflow,
    Size screenSize,
  ) {
    double xPosition = _getXPosition(widget.alignment.x, anchorRect, width);
    double yPosition = _getYPosition(widget.alignment.y, anchorRect, width);
    double shiftedXPosition = xPosition - xOverflow;
    double shiftedYPosition = yPosition - yOverflow;

    Rect topRect =
        Rect.fromLTWH(shiftedXPosition, anchorRect.top - height, width, height);
    Rect bottomRect =
        Rect.fromLTWH(shiftedXPosition, anchorRect.bottom, width, height);
    Rect leftRect =
        Rect.fromLTWH(anchorRect.left - width, shiftedYPosition, width, height);
    Rect rightRect =
        Rect.fromLTWH(anchorRect.right, shiftedYPosition, width, height);

    double topRectOverflow =
        _getCombinedAbsoluteOverflowSum(topRect, screenSize);
    double bottomRectOverflow =
        _getCombinedAbsoluteOverflowSum(bottomRect, screenSize);
    double leftRectOverflow =
        _getCombinedAbsoluteOverflowSum(leftRect, screenSize);
    double rightRectOverflow =
        _getCombinedAbsoluteOverflowSum(rightRect, screenSize);

    return [
      _OverlayRect.fromPoints(
          alignment: Alignment.topCenter,
          topLeft: topRect.topLeft,
          bottomRight: topRect.bottomRight,
          combinedOverflowSum: topRectOverflow),
      _OverlayRect.fromPoints(
          alignment: Alignment.bottomCenter,
          topLeft: bottomRect.topLeft,
          bottomRight: bottomRect.bottomRight,
          combinedOverflowSum: bottomRectOverflow),
      _OverlayRect.fromPoints(
          alignment: Alignment.centerLeft,
          topLeft: leftRect.topLeft,
          bottomRight: leftRect.bottomRight,
          combinedOverflowSum: leftRectOverflow),
      _OverlayRect.fromPoints(
          alignment: Alignment.centerRight,
          topLeft: rightRect.topLeft,
          bottomRight: rightRect.bottomRight,
          combinedOverflowSum: rightRectOverflow),
    ];
  }

  List<_OverlayRect> _getAbsoluteRects(
    Rect anchorRect,
    double height,
    double width,
    Size screenSize,
  ) {
    List<_OverlayRect> rects = [];
    List<Alignment> alignments = [
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.centerLeft,
      if (!widget.avoidOverlap) Alignment.center,
      Alignment.centerRight,
      Alignment.bottomLeft,
      Alignment.bottomCenter,
      Alignment.bottomRight,
    ];

    for (Alignment alignment in alignments) {
      Rect rect = _getOverlayRect(alignment, anchorRect, height, width);
      _OverlayRect overlayRect = _OverlayRect.fromPoints(
        alignment: alignment,
        topLeft: rect.topLeft,
        bottomRight: rect.bottomRight,
        combinedOverflowSum: _getCombinedAbsoluteOverflowSum(rect, screenSize),
      );

      rects.add(overlayRect);
    }

    return rects;
  }

  Offset _getRelativeOffset(Rect target, Rect other) {
    return Offset(
      other.left - target.left,
      other.top - target.top,
    );
  }

  double _getDistance(Offset offset) {
    return offset.dx * offset.dx + offset.dy * offset.dy;
  }

  _OverlayRect _getNearestRect(Rect target, List<_OverlayRect> rects) {
    double min = double.infinity;
    _OverlayRect closestRect = rects[0];

    for (_OverlayRect rect in rects) {
      double dist = _getDistance(_getRelativeOffset(target, rect));
      if (dist < min) {
        min = dist;
        closestRect = rect;
      }
    }
    return closestRect;
  }

  _OverlayRect _getBoundedRect(
    Rect anchorRect,
    double height,
    double width,
    Size screenSize,
  ) {
    _OverlayRect currentRect =
        _getOverlayRect(widget.alignment, anchorRect, height, width);
    double top = _getYPosition(widget.alignment.y, anchorRect, height);
    double left = _getXPosition(widget.alignment.x, anchorRect, width);

    double yOverflow = _getYOverflowSum(currentRect, screenSize);
    double xOverflow = _getXOverflowSum(currentRect, screenSize);

    if (yOverflow == 0 && xOverflow == 0) {
      return currentRect;
    }

    if (!widget.avoidOverlap && widget.flexiblePosition) {
      return _OverlayRect.fromLTWH(
        alignment: widget.alignment,
        combinedOverflowSum: 0,
        top: top - yOverflow,
        left: left - xOverflow,
        width: width,
        height: height,
      );
    }

    List<_OverlayRect> rects;
    if (widget.flexiblePosition) {
      rects = _getFlexibleRects(
          anchorRect, height, width, xOverflow, yOverflow, screenSize);
    } else {
      rects = _getAbsoluteRects(anchorRect, height, width, screenSize);
    }

    rects.sort((r1, r2) {
      double r1Overflow = r1.combinedOverflowSum;
      double r2Overflow = r2.combinedOverflowSum;
      return r1Overflow.compareTo(r2Overflow);
    });

    // determine if there are multiple viable options
    _OverlayRect firstRect = rects.first;
    List<_OverlayRect> viableRects = [];
    viableRects.add(firstRect);

    for (_OverlayRect rect in rects.skip(1)) {
      if (rect.combinedOverflowSum == firstRect.combinedOverflowSum) {
        viableRects.add(rect);
      }
    }

    // if more than one option, decide based on position
    if (viableRects.length > 1) {
      return _getNearestRect(currentRect, viableRects);
    } else {
      return viableRects.first;
    }
  }

  double _getAvailableHeight(double yAlign, Rect? anchorRect, Size screenSize) {
    if (anchorRect == null) return screenSize.height;

    if (yAlign == -1.0) {
      return anchorRect.top;
    } else if (yAlign == 0.0) {
      return screenSize.height;
    }
    return screenSize.height - anchorRect.bottom;
  }

  double _getAvailableWidth(double xAlign, Rect? anchorRect, Size screenSize) {
    if (anchorRect == null) return screenSize.width;

    if (xAlign == -1.0) {
      return anchorRect.left;
    } else if (xAlign == 0.0) {
      return screenSize.width;
    }
    return screenSize.width - anchorRect.right;
  }

  @override
  Widget build(BuildContext context) {
    final Rect? anchorRect = widget.anchor ? getAnchorRect() : null;
    final Size screenSize = MediaQuery.sizeOf(context);

    double availableWidth =
        _getAvailableWidth(widget.alignment.x, anchorRect, screenSize);
    double minWidth = widget.minWidth ?? 0;
    double maxWidth = widget.maxWidth ?? availableWidth;
    final double width = widget.width ?? anchorRect?.width ?? maxWidth;
    final double clampedWidth = width.clamp(
      minWidth,
      maxWidth > minWidth ? maxWidth : minWidth,
    );

    double availableHeight =
        _getAvailableHeight(widget.alignment.y, anchorRect, screenSize);
    double minHeight = widget.minHeight ?? 0;
    double maxHeight = widget.maxHeight ?? availableHeight;
    double height = widget.height ?? availableHeight;

    if (maxHeight > availableHeight) {
      maxHeight = availableHeight;
    }

    double clampedHeight = height.clamp(
      minHeight > screenSize.height ? screenSize.height : minHeight,
      maxHeight > minHeight ? maxHeight : minHeight,
    );

    double xOffset =
        _getXOffset(widget.alignment.x, anchorRect, screenSize, clampedWidth);
    double yOffset =
        _getYOffset(widget.alignment.y, anchorRect, clampedHeight, screenSize);

    if (widget.keepInBounds && anchorRect != null) {
      _OverlayRect adjustedRect = _getBoundedRect(
        anchorRect,
        clampedHeight,
        clampedWidth,
        screenSize,
      );
      Offset adjustedOffset = _getRelativeOffset(anchorRect, adjustedRect);
      xOffset = adjustedOffset.dx;
      yOffset = adjustedOffset.dy;
    }

    // If not using CompositedTransformFollower, values of Positioned should
    // be set in order for the SizeTransition to open from top.
    return ConditionalParentWidget(
      condition: !widget.anchor,
      parentBuilder: (child) {
        return Positioned(
          top: 0,
          left: 0,
          child: child,
        );
      },
      child: TapRegion(
        onTapOutside: widget.onTapOutside,
        // need Align for SizeTransition to work
        child: Align(
          child: ConditionalParentWidget(
            condition: widget.anchor,
            parentBuilder: (child) {
              return CompositedTransformFollower(
                link: widget.layerLink,
                showWhenUnlinked: false,
                offset: Offset(xOffset, yOffset),
                child: child,
              );
            },
            child: SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: widget.animationController,
                curve: Curves.fastOutSlowIn,
              ),
              axisAlignment: -1,
              child: SizedBox(
                // review: handle width
                height: widget.sizeXToChild ? null : clampedHeight,
                width: clampedWidth,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OverlayAnchorController {
  _OverlayAnchorState? _anchor;

  void showOverlay() {
    _anchor?._openOverlay();
  }

  void hideOverlay() {
    _anchor?._removeOverlay();
  }
}

class _OverlayRect extends Rect {
  double combinedOverflowSum;
  Alignment alignment;

  _OverlayRect.fromLTWH({
    required this.alignment,
    required this.combinedOverflowSum,
    required double left,
    required double top,
    required double width,
    required double height,
  }) : super.fromLTWH(left, top, width, height);

  _OverlayRect.fromPoints({
    required this.alignment,
    required this.combinedOverflowSum,
    required Offset topLeft,
    required Offset bottomRight,
  }) : super.fromPoints(topLeft, bottomRight);

  _OverlayRect copyWith() {
    return _OverlayRect.fromPoints(
      alignment: alignment,
      combinedOverflowSum: combinedOverflowSum,
      topLeft: topLeft,
      bottomRight: bottomRight,
    );
  }
}
