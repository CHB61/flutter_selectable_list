import 'package:flutter/material.dart';
import 'selectable_list.dart';
import 'selectable_list_anchor.dart';
import 'selectable_list_defaults_mixin.dart';

class SelectableListDropdown<T> extends StatefulWidget {
  final Widget? actions;

  /// Sets the backgroundColor of the [Dialog] and the tileColor of [CheckboxListTile].
  ///
  /// Note: This hides the elevation of the [Material] wrapped around [CheckboxListTile]
  /// because [ListTile.tileColor] is used on an [Ink] widget that is displayed above the [Material].
  ///
  /// You can set the [elevation] to restore the Dialog elevation, but it will
  /// not be visible on the default list items, making them appear lighter.
  final Color? backgroundColor;

  /// Overrides the default header and any properties used by it such as
  /// [headerTitle].
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

  final bool isThreeLine;

  final bool multiselect;

  final void Function(String)? onSearchTextChanged;
  final void Function(T?)? onSingleSelectionChanged;
  final OnMultiSelectionChanged onMultiSelectionChanged;

  final SingleSelectController<T>? singleSelectController;
  final MultiSelectController<T>? multiSelectController;

  final EdgeInsetsGeometry? padding;

  /// Widget to be displayed when [SelectableListController.loading] is `true`.
  /// The position of this widget can be set using the [SelectableListController.progressIndicatorPosition].
  final Widget? progressIndicator;

  /// Enables the search functionality for the default header.
  /// Display the default header by setting [showDefaultHeader] to `true`.
  /// Has no effect when [header] is provided.
  final bool searchable;

  final Widget Function(TextEditingController, Widget)? searchViewBuilder;

  final Widget Function(T)? secondary;

  final bool showDefaultHeader;

  final Widget Function(T)? subtitle;

  final Function? onMaxScrollExtent;

  const SelectableListDropdown.single({
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
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    void Function(T?)? onSelectionChanged,
    this.padding,
    this.progressIndicator,
    this.searchable = false,
    this.searchViewBuilder,
    this.secondary,
    this.showDefaultHeader = false,
    this.subtitle,
  })  : multiselect = false,
        multiSelectController = null,
        onMultiSelectionChanged = null,
        onSingleSelectionChanged = onSelectionChanged,
        singleSelectController = controller;

  const SelectableListDropdown.multi({
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
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    OnMultiSelectionChanged onSelectionChanged,
    this.padding,
    this.progressIndicator,
    this.searchable = false,
    this.searchViewBuilder,
    this.secondary,
    this.showDefaultHeader = false,
    this.subtitle,
  })  : multiselect = true,
        singleSelectController = null,
        onMultiSelectionChanged = onSelectionChanged,
        onSingleSelectionChanged = null,
        multiSelectController = controller;

  @override
  State<SelectableListDropdown<T>> createState() =>
      _SelectableListDropdownState<T>();
}

class _SelectableListDropdownState<T> extends State<SelectableListDropdown<T>>
    with ModalDefaultsMixin<T> {
  late SelectableListController<T> _controller;

  @override
  void initState() {
    super.initState();

    widget.multiselect
        ? _controller = widget.multiSelectController!
        : _controller = widget.singleSelectController!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        children: [
          widget.header ??
              (widget.showDefaultHeader
                  ? getDefaultModalHeader(
                      controller: _controller,
                      headerTitle: widget.headerTitle,
                      searchable: widget.searchable,
                      onSearchTextChanged: widget.onSearchTextChanged,
                      itemTitle: widget.itemTitle,
                      padding: const EdgeInsets.fromLTRB(12, 4, 8, 0),
                    )
                  : Container()),
          if (widget.showDefaultHeader || widget.header != null)
            Divider(
              height: 1,
              color: widget.dividerColor,
            ),
          Expanded(
            child: widget.multiselect
                ? SelectableList<T>.multi(
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
                    searchViewBuilder: widget.searchViewBuilder,
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
                    searchViewBuilder: widget.searchViewBuilder,
                  ),
          ),
          if (widget.actions != null)
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
