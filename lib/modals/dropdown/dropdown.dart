import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/modals/side_sheet/side_sheet_theme.dart';

enum DropdownAligmnent {
  center,
  left,
  right,
}

/// The horizontal position is determined by the [alignment] parameter
/// which defaults to `DropdownAlignment.center`. The vertical position
/// will be at the top of the screen unless [anchorKey] is provided - then it
/// will be below the anchor widget.
///
/// If an [offset] is provided, it will be applied to the starting position.
///
/// If no [width] is provided, the dropdown will match the width of the anchor
/// if `anchorKey` is provided, otherwise a default width will be used.
Future<T?> showModalDropdown<T>({
  GlobalKey? anchorKey,
  DropdownAligmnent alignment = DropdownAligmnent.center,
  Color? barrierColor,
  bool barrierDismissible = true,
  String? barrierLabel,
  required WidgetBuilder builder,
  required BuildContext context,
  Duration transitionDuration = const Duration(milliseconds: 400),
  Offset? offset,
  double? width,
  BoxConstraints? constraints,
}) {
  final NavigatorState navigator = Navigator.of(context);
  return navigator.push(
    DropdownRoute<T>(
      alignment: alignment,
      anchorKey: anchorKey,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      builder: builder,
      constraints: constraints,
      offset: offset,
      transitionDuration: transitionDuration,
      width: width,
    ),
  );
}

class DropdownRoute<T> extends PopupRoute<T> {
  DropdownRoute({
    this.anchorKey,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor = const Color(0x80000000),
    String? barrierLabel,
    TextDirection direction = TextDirection.ltr,
    this.offset,
    Duration transitionDuration = const Duration(milliseconds: 400),
    double? width,
    this.alignment = DropdownAligmnent.center,
    this.constraints,
    super.settings,
    super.traversalEdgeBehavior,
  })  : _barrierColor = barrierColor,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _builder = builder,
        _transitionDuration = transitionDuration,
        _width = width;

  final WidgetBuilder _builder;
  final double? _width;
  final GlobalKey? anchorKey;
  final Offset? offset;
  final BoxConstraints? constraints;
  final DropdownAligmnent alignment;

  final Duration _transitionDuration;
  final Color? _barrierColor;
  final bool _barrierDismissible;
  final String? _barrierLabel;

  Rect? getRect() {
    final BuildContext? context = anchorKey?.currentContext;
    if (context != null) {
      final RenderBox anchorBox = context.findRenderObject()! as RenderBox;
      final Size boxSize = anchorBox.size;
      final Offset boxLocation = anchorBox.localToGlobal(
        Offset.zero,
      );
      return boxLocation & boxSize;
    }
    return null;
  }

  double _defaultWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 500) return screenWidth * 0.25;
    return screenWidth * 0.75;
  }

  double _getXOffset(Rect? anchorRect, Size screenSize, double width) {
    double xOffset;

    xOffset = alignment == DropdownAligmnent.center
        ? screenSize.width / 2
        : alignment == DropdownAligmnent.right
            ? screenSize.width - width
            : 0;

    if (anchorRect != null) {
      double width = _width ?? anchorRect.width;
      double centerOffset = (anchorRect.center.dx) - (width / 2);
      double leftOffset = (anchorRect.left) - (width);
      double rightOffset = (anchorRect.right);

      xOffset = alignment == DropdownAligmnent.center
          ? centerOffset
          : alignment == DropdownAligmnent.right
              ? rightOffset
              : leftOffset;
    }
    return offset != null ? offset!.dx + xOffset : xOffset;
  }

  double _getYOffset(Rect? anchorRect) {
    double yOffset = 0;

    if (anchorRect != null) {
      yOffset = anchorRect.top + anchorRect.height + 5;
    }
    return offset != null ? offset!.dy + yOffset : yOffset;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Rect? anchorRect = getRect();
    final Size screenSize = MediaQuery.of(context).size;
    final double width = _width ?? anchorRect?.width ?? _defaultWidth(context);

    double xOffset = _getXOffset(anchorRect, screenSize, width);
    double yOffset = _getYOffset(anchorRect);

    double maxHeight = (screenSize.height - yOffset - 15).isNegative
        ? 100
        : screenSize.height - yOffset - 15;

    SideSheetTheme defaults = _DropdownDefaultsM3(context);

    Widget child = Material(
      elevation: defaults.elevation!,
      clipBehavior: Clip.antiAlias,
      // color: Theme.of(context).colorScheme.surface,
      shadowColor: defaults.shadowColor,
      surfaceTintColor: defaults.surfaceTintColor,
      shape: defaults.shape!,
      child: ConstrainedBox(
        constraints: constraints ?? BoxConstraints(maxHeight: maxHeight),
        child: SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          ),
          axisAlignment: -1,
          child: _builder(context),
        ),
      ),
    );

    Widget dropdownContainer = Stack(
      children: [
        Positioned(
          left: xOffset,
          top: yOffset,
          width: width,
          child: child,
        ),
      ],
    );

    return dropdownContainer;
  }

  @override
  Color? get barrierColor => _barrierColor ?? Colors.black54;

  @override
  bool get barrierDismissible => _barrierDismissible;

  @override
  String? get barrierLabel => _barrierLabel;

  @override
  Duration get transitionDuration => _transitionDuration;
}

class _DropdownDefaultsM3 extends SideSheetTheme {
  _DropdownDefaultsM3(this.context)
      : super(
          alignment: Alignment.center,
          elevation: 6.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(28.0))),
        );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Color? get iconColor => _colors.secondary;

  @override
  Color? get backgroundColor => _colors.surface;

  @override
  Color? get shadowColor => Theme.of(context).shadowColor;

  @override
  Color? get surfaceTintColor => _colors.surfaceTint;

  @override
  TextStyle? get titleTextStyle => _textTheme.headlineSmall;

  @override
  TextStyle? get contentTextStyle => _textTheme.bodyMedium;
}
