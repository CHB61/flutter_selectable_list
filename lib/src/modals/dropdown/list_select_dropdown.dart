import 'package:flutter/material.dart';
import '../../selectable_list.dart';
import '../../selectable_list_anchor.dart';
import '../../modals/modal_defaults_mixin.dart';

class ListSelectDropdown<T> extends StatefulWidget {
  final Widget? actions;

  /// Sets the backgroundColor of the [Dialog] and the tileColor of [CheckboxListTile].
  ///
  /// Note: This hides the elevation of the [Material] wrapped around [CheckboxListTile]
  /// because [ListTile.tileColor] is used on an [Ink] widget that is displayed above the [Material].
  ///
  /// You can set the [elevation] to restore the Dialog elevation, but it will
  /// not be visible on the default list items, making them appear lighter.
  final Color? backgroundColor;

  /// Overrides [headerTitle].
  final Widget? header;

  /// The title of the Dialog.
  ///
  /// The default value is "Select" and the [TextStyle] uses [TextTheme.titleLarge].
  /// Override this widget by using the [dialogHeader].
  final String? headerTitle;

  /// If this is null, then [DividerThemeData.color] is used. If that is also
  /// null, then if [ThemeData.useMaterial3] is true then it defaults to
  /// [ThemeData.colorScheme]'s [ColorScheme.outlineVariant]. Otherwise
  /// [ThemeData.dividerColor] is used.
  final Color? dividerColor;

  /// Sets the elevation of the [Dialog] and the [Material] wrapped around
  /// [CheckboxListTile].
  ///
  /// Note: The elevation of the [ListTile] is hidden when [ListTile.tileColor] is
  /// not transparent.
  final double? elevation;

  /// Overrides the default [CheckboxListTile].
  final Widget Function(T item, int index)? itemBuilder;

  // final Widget Function(T)? itemTitle;
  final String Function(T)? itemTitle;

  final bool multiselect;

  /// Called when confirm is tapped.
  final void Function(T)? onConfirmSingle;
  final void Function(List<T>)? onConfirmMulti;

  final void Function(String)? onSearchTextChanged;
  final void Function(T?)? onSingleSelectionChanged;
  final void Function(List<T>, T, bool)? onMultiSelectionChanged;

  final SingleSelectController<T>? singleSelectController;
  final MultiSelectController<T>? multiSelectController;

  final EdgeInsetsGeometry? padding;

  /// Widget to be displayed when [SelectableListController.loading] is `true`.
  /// The position of this widget can be set using the [SelectableListController.progressIndicatorPosition].
  final Widget? progressIndicator;

  /// Enables the default search functionality. Has no effect when [dialogHeader] is provided.
  final bool searchable;
  final Widget Function(TextEditingController, Widget)? searchBuilder;
  final Widget Function(T)? secondary;
  final Widget Function(T)? subtitle;
  final bool isThreeLine;

  final Function? onMaxScrollExtent;

  const ListSelectDropdown.single({
    super.key,
    this.actions,
    this.backgroundColor,
    required SingleSelectController<T> controller,
    this.header,
    this.headerTitle,
    this.dividerColor,
    this.elevation,
    this.isThreeLine = false,
    this.itemBuilder,
    this.itemTitle,
    void Function(T)? onConfirm,
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    void Function(T?)? onSelectionChanged,
    this.padding,
    this.progressIndicator,
    this.searchable = false,
    this.searchBuilder,
    this.secondary,
    this.subtitle,
  })  : multiselect = false,
        multiSelectController = null,
        onMultiSelectionChanged = null,
        onConfirmMulti = null,
        onConfirmSingle = onConfirm,
        onSingleSelectionChanged = onSelectionChanged,
        singleSelectController = controller;

  const ListSelectDropdown.multi({
    super.key,
    this.actions,
    this.backgroundColor,
    required MultiSelectController<T>? controller,
    this.header,
    this.headerTitle,
    this.dividerColor,
    this.elevation,
    this.isThreeLine = false,
    this.itemBuilder,
    this.itemTitle,
    void Function(List<T>)? onConfirm,
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    void Function(List<T>, T, bool)? onSelectionChanged,
    this.padding,
    this.progressIndicator,
    this.searchable = false,
    this.searchBuilder,
    this.secondary,
    this.subtitle,
  })  : multiselect = true,
        singleSelectController = null,
        onSingleSelectionChanged = null,
        onConfirmSingle = null,
        onConfirmMulti = onConfirm,
        onMultiSelectionChanged = onSelectionChanged,
        multiSelectController = controller;

  @override
  State<ListSelectDropdown<T>> createState() => _ListSelectDropdownState<T>();
}

class _ListSelectDropdownState<T> extends State<ListSelectDropdown<T>>
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
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        children: [
          widget.header ?? Container(),
          if (widget.header != null)
            Divider(
              height: 1,
              color: widget.dividerColor,
            ),
          widget.multiselect
              ? Expanded(
                  child: SelectableList<T>.multi(
                    backgroundColor: widget.backgroundColor,
                    controller: _controller as MultiSelectController<T>,
                    elevation: widget.elevation ?? 6,
                    isThreeLine: widget.isThreeLine,
                    itemBuilder: widget.itemBuilder,
                    itemTitle: widget.itemTitle,
                    onSelectionChanged: widget.onMultiSelectionChanged,
                    progressIndicator: widget.progressIndicator,
                    secondary: widget.secondary,
                    subtitle: widget.subtitle,
                    onScrollThresholdReached: widget.onMaxScrollExtent,
                    searchBuilder: widget.searchBuilder,
                  ),
                )
              : SelectableList.single(
                  backgroundColor: widget.backgroundColor,
                  controller: _controller as SingleSelectController<T>,
                  elevation: widget.elevation ?? 6,
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
          if (widget.header != null)
            Divider(
              height: 1,
              color: widget.dividerColor,
            ),
          widget.actions ?? Container(),
        ],
      ),
    );
  }
}
