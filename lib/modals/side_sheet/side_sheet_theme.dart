import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Defines a theme for [SideSheet] widgets.
class SideSheetTheme with Diagnosticable {
  /// Creates a side sheet theme.
  const SideSheetTheme({
    this.backgroundColor,
    this.elevation,
    this.insetPadding,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.alignment,
    this.iconColor,
    this.titleTextStyle,
    this.contentTextStyle,
  });

  /// Overrides the default value for [SideSheet.backgroundColor].
  final Color? backgroundColor;

  /// Overrides the default value for [SideSheet.elevation].
  final double? elevation;

  /// Overrides the default value for [SideSheet.insetPadding]
  final EdgeInsetsGeometry? insetPadding;

  /// Overrides the default value for [SideSheet.shadowColor].
  final Color? shadowColor;

  /// Overrides the default value for [SideSheet.surfaceTintColor].
  final Color? surfaceTintColor;

  /// Overrides the default value for [SideSheet.shape].
  final ShapeBorder? shape;

  /// Overrides the default value for [SideSheet.alignment].
  final AlignmentGeometry? alignment;

  /// Overrides the default value for [DefaultTextStyle] for [SideSheet.title].
  final TextStyle? titleTextStyle;

  /// Overrides the default value for [DefaultTextStyle] for [SideSheet.conent].
  final TextStyle? contentTextStyle;

  /// Used to configure the [IconTheme] for the [SideSheet.icon] widget.
  final Color? iconColor;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  SideSheetTheme copyWith({
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? insetPadding,
    Color? shadowColor,
    Color? surfaceTintColor,
    ShapeBorder? shape,
    AlignmentGeometry? alignment,
    Color? iconColor,
    TextStyle? titleTextStyle,
    TextStyle? contentTextStyle,
    EdgeInsetsGeometry? actionsPadding,
  }) {
    return SideSheetTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      insetPadding: insetPadding ?? this.insetPadding,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      shape: shape ?? this.shape,
      alignment: alignment ?? this.alignment,
      iconColor: iconColor ?? this.iconColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
    );
  }

  @override
  int get hashCode => shape.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SideSheetTheme &&
        other.backgroundColor == backgroundColor &&
        other.elevation == elevation &&
        other.insetPadding == insetPadding &&
        other.shadowColor == shadowColor &&
        other.surfaceTintColor == surfaceTintColor &&
        other.shape == shape &&
        other.alignment == alignment &&
        other.iconColor == iconColor &&
        other.titleTextStyle == titleTextStyle &&
        other.contentTextStyle == contentTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(DoubleProperty('elevation', elevation));
    properties.add(
        DiagnosticsProperty<EdgeInsetsGeometry>('insetPadding', insetPadding));
    properties.add(ColorProperty('shadowColor', shadowColor));
    properties.add(ColorProperty('surfaceTintColor', surfaceTintColor));
    properties.add(
        DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null));
    properties.add(DiagnosticsProperty<AlignmentGeometry>(
        'alignment', alignment,
        defaultValue: null));
    properties.add(ColorProperty('iconColor', iconColor));
    properties.add(DiagnosticsProperty<TextStyle>(
        'titleTextStyle', titleTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>(
        'contentTextStyle', contentTextStyle,
        defaultValue: null));
  }
}
