import 'package:flutter/material.dart';
import 'selectable_list.dart';
import 'selectable_list_anchor.dart';
import 'selectable_list_defaults_mixin.dart';

class SelectableListSideSheet<T> extends StatefulWidget {
  final Widget? actions;

  /// Sets the backgroundColor of the [Dialog] and the tileColor of [CheckboxListTile].
  ///
  /// Note: This hides the elevation of the [Material] wrapped around [CheckboxListTile]
  /// because [ListTile.tileColor] is used on an [Ink] widget that is displayed above the [Material].
  ///
  /// You can set the [elevation] to restore the Dialog elevation, but it will
  /// not be visible on the default list items, making them appear lighter.
  final Color? backgroundColor;

  /// If this is null, then [DividerThemeData.color] is used. If that is also
  /// null, then if [ThemeData.useMaterial3] is true then it defaults to
  /// [ThemeData.colorScheme]'s [ColorScheme.outlineVariant]. Otherwise
  /// [ThemeData.dividerColor] is used.
  final Color? dividerColor;

  /// Replaces the default header.
  final Widget? header;

  /// The default value is "Select" and the [TextStyle] uses [TextTheme.titleLarge].
  final String? headerTitle;

  /// Sets the elevation of the [Dialog] and the [Material] wrapped around
  /// [CheckboxListTile].
  ///
  /// Note: The elevation of the [ListTile] is hidden when [ListTile.tileColor] is
  /// not transparent.
  final double? elevation;

  /// Overrides the default [CheckboxListTile].
  final Widget Function(T item, int index)? itemBuilder;

  final EdgeInsetsGeometry? insetPadding;
  final bool isThreeLine;
  final String Function(T)? itemTitle;

  final bool multiselect;

  /// Called when confirm is tapped.
  final void Function(T?)? onConfirmSingle;
  final void Function(List<T>)? onConfirmMulti;

  final OnMultiSelectionChanged onMultiSelectionChanged;
  final void Function(String)? onSearchTextChanged;
  final void Function(T?)? onSingleSelectionChanged;

  final SingleSelectController<T>? singleSelectController;
  final MultiSelectController<T>? multiSelectController;

  final EdgeInsetsGeometry? padding;

  /// Widget to be displayed when [SelectableListController.loading] is `true`.
  /// The position of this widget can be set using the [SelectableListController.progressIndicatorPosition].
  final Widget? progressIndicator;

  /// Enables the default search functionality. Has no effect when [header] is provided.
  final bool searchable;

  final Widget Function(TextEditingController, Widget)? searchViewBuilder;
  final Widget Function(T)? secondary;

  final ShapeBorder? shape;

  final Widget Function(T)? subtitle;

  final Function? onMaxScrollExtent;

  const SelectableListSideSheet.single({
    super.key,
    this.actions,
    this.backgroundColor,
    required SingleSelectController<T> controller,
    this.header,
    this.headerTitle,
    this.dividerColor,
    this.elevation,
    this.insetPadding,
    this.isThreeLine = false,
    this.itemBuilder,
    this.itemTitle,
    void Function(T?)? onConfirm,
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    void Function(T?)? onSelectionChanged,
    this.padding,
    this.progressIndicator,
    this.searchable = false,
    this.searchViewBuilder,
    this.secondary,
    this.shape,
    this.subtitle,
  })  : multiselect = false,
        multiSelectController = null,
        onMultiSelectionChanged = null,
        onConfirmMulti = null,
        onConfirmSingle = onConfirm,
        onSingleSelectionChanged = onSelectionChanged,
        singleSelectController = controller;

  const SelectableListSideSheet.multi({
    super.key,
    this.actions,
    this.backgroundColor,
    required MultiSelectController<T>? controller,
    this.header,
    this.headerTitle,
    this.dividerColor,
    this.elevation,
    this.insetPadding,
    this.isThreeLine = false,
    this.itemBuilder,
    this.itemTitle,
    void Function(List<T>)? onConfirm,
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    OnMultiSelectionChanged onSelectionChanged,
    this.padding,
    this.progressIndicator,
    this.searchable = false,
    this.searchViewBuilder,
    this.secondary,
    this.shape,
    this.subtitle,
  })  : multiselect = true,
        singleSelectController = null,
        onSingleSelectionChanged = null,
        onConfirmSingle = null,
        onConfirmMulti = onConfirm,
        onMultiSelectionChanged = onSelectionChanged,
        multiSelectController = controller;

  @override
  State<SelectableListSideSheet<T>> createState() =>
      _SelectableListSideSheetState<T>();
}

class _SelectableListSideSheetState<T> extends State<SelectableListSideSheet<T>>
    with ModalDefaultsMixin<T> {
  // Used to pop with the initial value when cancel is tapped.
  List<T> originalValue = [];

  late SelectableListController<T> _controller;

  @override
  void initState() {
    super.initState();

    widget.multiselect
        ? _controller = widget.multiSelectController!
        : _controller = widget.singleSelectController!;

    widget.multiselect
        ? originalValue = [..._controller.value]
        : originalValue = _controller.value != null ? [_controller.value] : [];
  }

  @override
  Widget build(BuildContext context) {
    _SideSheetDefaultsM3 defaults = _SideSheetDefaultsM3(context);

    return Padding(
      padding: widget.insetPadding ?? defaults.insetPadding,
      child: Material(
        elevation: widget.elevation ?? defaults.elevation,
        clipBehavior: Clip.hardEdge,
        color: widget.backgroundColor ?? defaults.backgroundColor,
        shadowColor: defaults.shadowColor,
        surfaceTintColor: defaults.surfaceTintColor,
        shape: widget.shape ?? defaults.shape,
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(24),
          child: Column(
            children: [
              widget.header ??
                  getDefaultModalHeader(
                    controller: _controller,
                    headerTitle: widget.headerTitle,
                    searchable: widget.searchable,
                    onSearchTextChanged: widget.onSearchTextChanged,
                    itemTitle: widget.itemTitle,
                  ),
              Divider(
                height: 1,
                color: widget.dividerColor,
              ),
              Expanded(
                child: widget.multiselect
                    ? SelectableList<T>.multi(
                        backgroundColor: widget.backgroundColor,
                        controller: _controller as MultiSelectController<T>,
                        elevation: widget.elevation ?? defaults.elevation,
                        isThreeLine: widget.isThreeLine,
                        itemBuilder: widget.itemBuilder,
                        itemTitle: widget.itemTitle,
                        onSelectionChanged: widget.onMultiSelectionChanged,
                        progressIndicator: widget.progressIndicator,
                        secondary: widget.secondary,
                        subtitle: widget.subtitle,
                        onScrollThresholdReached: widget.onMaxScrollExtent,
                        searchViewBuilder: widget.searchViewBuilder,
                      )
                    : SelectableList.single(
                        backgroundColor: widget.backgroundColor,
                        controller: _controller as SingleSelectController<T>,
                        elevation: widget.elevation ?? defaults.elevation,
                        isThreeLine: widget.isThreeLine,
                        itemBuilder: widget.itemBuilder,
                        itemTitle: widget.itemTitle,
                        onSelectionChanged: widget.onSingleSelectionChanged,
                        progressIndicator: widget.progressIndicator,
                        secondary: widget.secondary,
                        subtitle: widget.subtitle,
                        onScrollThresholdReached: widget.onMaxScrollExtent,
                        searchViewBuilder: widget.searchViewBuilder,
                      ),
              ),
              Divider(
                height: 1,
                color: widget.dividerColor,
              ),
              widget.actions ??
                  getDefaultModalActions(
                    controller: _controller,
                    multiselect: widget.multiselect,
                    originalValue: originalValue,
                    onConfirmMulti: widget.onConfirmMulti,
                    onConfirmSingle: widget.onConfirmSingle,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideSheetDefaultsM3 {
  _SideSheetDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  Alignment get alignment => Alignment.center;
  double get elevation => 6.0;
  EdgeInsetsGeometry get insetPadding => const EdgeInsets.all(8);
  ShapeBorder get shape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
      );
  Color? get backgroundColor => _colors.surface;
  Color? get shadowColor => Colors.transparent;
  Color? get surfaceTintColor => _colors.surfaceTint;
}
