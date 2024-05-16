import 'package:flutter/material.dart';
import 'selectable_list.dart';
import 'selectable_list_anchor.dart';
import 'selectable_list_defaults_mixin.dart';
import 'modal/side_sheet.dart';

class ListSelectSideSheet<T> extends StatefulWidget {
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
  final void Function(T)? onConfirmSingle;
  final void Function(List<T>)? onConfirmMulti;

  final void Function(List<T>, T, bool)? onMultiSelectionChanged;
  final void Function(String)? onSearchTextChanged;
  final void Function(T?)? onSingleSelectionChanged;

  final SingleSelectController<T>? singleSelectController;
  final MultiSelectController<T>? multiSelectController;

  /// Widget to be displayed when [SelectableListController.loading] is `true`.
  /// The position of this widget can be set using the [SelectableListController.progressIndicatorPosition].
  final Widget? progressIndicator;

  /// Enables the default search functionality. Has no effect when [header] is provided.
  final bool searchable;

  final Widget Function(TextEditingController, Widget)? searchBuilder;
  final Widget Function(T)? secondary;

  final ShapeBorder? shape;

  final Widget Function(T)? subtitle;

  final Function? onMaxScrollExtent;

  const ListSelectSideSheet.single({
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
    void Function(T)? onConfirm,
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    void Function(T?)? onSelectionChanged,
    this.progressIndicator,
    this.searchable = false,
    this.searchBuilder,
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

  const ListSelectSideSheet.multi({
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
    void Function(List<T>, T, bool)? onSelectionChanged,
    this.progressIndicator,
    this.searchable = false,
    this.searchBuilder,
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
  State<ListSelectSideSheet<T>> createState() => _ListSelectSideSheetState<T>();
}

class _ListSelectSideSheetState<T> extends State<ListSelectSideSheet<T>>
    with ModalDefaultsMixin<T> {
  // Stores the controller value when opened (initState is invoked).
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
    return SideSheet(
      backgroundColor: widget.backgroundColor,
      shape: widget.shape,
      insetPadding: widget.insetPadding,
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                      elevation: widget.elevation,
                      isThreeLine: widget.isThreeLine,
                      itemBuilder: widget.itemBuilder,
                      itemTitle: widget.itemTitle,
                      onSelectionChanged: widget.onMultiSelectionChanged,
                      progressIndicator: widget.progressIndicator,
                      secondary: widget.secondary,
                      subtitle: widget.subtitle,
                      onScrollThresholdReached: widget.onMaxScrollExtent,
                      searchBuilder: widget.searchBuilder,
                    )
                  : SelectableList.single(
                      backgroundColor: widget.backgroundColor,
                      controller: _controller as SingleSelectController<T>,
                      elevation: widget.elevation,
                      isThreeLine: widget.isThreeLine,
                      itemBuilder: widget.itemBuilder,
                      itemTitle: widget.itemTitle,
                      onSelectionChanged: widget.onSingleSelectionChanged,
                      progressIndicator: widget.progressIndicator,
                      secondary: widget.secondary,
                      subtitle: widget.subtitle,
                      onScrollThresholdReached: widget.onMaxScrollExtent,
                      searchBuilder: widget.searchBuilder,
                    ),
            ),
            Divider(
              height: 1,
              color: widget.dividerColor,
            ),
            widget.actions ??
                getDefaultModalActions(
                  controller: _controller,
                  originalValue: originalValue,
                  onConfirm: () {
                    Navigator.pop(context, _controller.value);
                    widget.multiselect
                        ? widget.onConfirmMulti?.call(_controller.value)
                        : widget.onConfirmSingle?.call(_controller.value);
                  },
                ),
          ],
        ),
      ),
    );
  }
}
