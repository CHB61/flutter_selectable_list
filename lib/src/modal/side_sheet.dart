import 'package:flutter/material.dart';

Future<T?> showModalSideSheet<T>({
  Color barrierColor = const Color(0x80000000),
  bool barrierDismissible = true,
  String? barrierLabel,
  required WidgetBuilder builder,
  required BuildContext context,
  RouteTransitionsBuilder? transitionBuilder,
  double? axisAlignment,
  TextDirection direction = TextDirection.ltr,
  double? width,
}) {
  final NavigatorState navigator = Navigator.of(context);
  return navigator.push<T>(
    SideSheetRoute<T>(
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: builder,
      transitionBuilder: transitionBuilder,
      direction: direction,
      width: width,
    ),
  );
}

class SideSheetRoute<T> extends PopupRoute<T> {
  SideSheetRoute({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
    String? barrierLabel,
    Duration transitionDuration = const Duration(milliseconds: 500),
    RouteTransitionsBuilder? transitionBuilder,
    TextDirection direction = TextDirection.ltr,
    double? width,
    super.settings,
    super.traversalEdgeBehavior,
  })  : _barrierColor = barrierColor,
        _barrierDismissible = barrierDismissible,
        _barrierLabel = barrierLabel,
        _builder = builder,
        _transitionBuilder = transitionBuilder,
        _transitionDuration = transitionDuration,
        _direction = direction,
        _width = width;

  final WidgetBuilder _builder;
  final RouteTransitionsBuilder? _transitionBuilder;
  final TextDirection _direction;
  final double? _width;

  final Duration _transitionDuration;
  final bool _barrierDismissible;
  final Color _barrierColor;
  final String? _barrierLabel;

  double _defaultWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 500) return screenWidth * 0.25;
    return screenWidth * 0.75;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Alignment alignment = _direction == TextDirection.ltr
        ? Alignment.centerLeft
        : Alignment.centerRight;

    final double width = _width ?? _defaultWidth(context);

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(width: _width ?? width),
        child: _builder(context),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (_transitionBuilder == null) {
      final double axisAlignment = _direction == TextDirection.ltr ? -1 : 1;

      return SlideTransition(
        position: Tween(
          begin: Offset(axisAlignment, 0),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubicEmphasized,
          ),
        ),
        child: child,
      );
    }
    return _transitionBuilder(context, animation, secondaryAnimation, child);
  }

  @override
  Color? get barrierColor => _barrierColor;

  @override
  bool get barrierDismissible => _barrierDismissible;

  @override
  String? get barrierLabel => _barrierLabel;

  @override
  Duration get transitionDuration => _transitionDuration;
}
