import 'package:flutter/material.dart';
import 'selectable_list.dart';
import 'selectable_list_anchor.dart';
import 'selectable_list_defaults_mixin.dart';

class SelectableListBottomSheet<T> extends StatefulWidget {
  final Widget? actions;

  /// Sets the background color of the [DraggableScrollableSheet] and the tileColor of [CheckboxListTile].
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

  /// Sets the elevation of the [Dialog] and the [Material] wrapped around
  /// [CheckboxListTile].
  ///
  /// Note: The elevation of the [ListTile] is hidden when [ListTile.tileColor] is
  /// not transparent.
  final double? elevation;

  /// Replaces the default header.
  final Widget? header;

  /// The default value is "Select" and the [TextStyle] uses [TextTheme.titleLarge].
  final String? headerTitle;

  final double initialChildSize;

  final bool isThreeLine;

  final String Function(T)? itemTitle;

  final double maxChildSize;
  final double minChildSize;

  final bool multiselect;

  final SingleSelectController<T>? singleSelectController;
  final MultiSelectController<T>? multiSelectController;

  final void Function(T?)? onConfirmSingle;
  final void Function(List<T>)? onConfirmMulti;

  final OnMultiSelectionChanged onMultiSelectionChanged;
  final void Function(String)? onSearchTextChanged;
  final void Function(T?)? onSingleSelectionChanged;

  /// Enables the default search functionality. Has no effect when [header] is provided.
  final bool searchable;

  final Widget Function(TextEditingController, Widget)? searchBuilder;
  final Widget Function(T)? secondary;
  final Widget Function(T)? subtitle;

  final ShapeBorder? shape;

  const SelectableListBottomSheet.single({
    super.key,
    this.actions,
    this.backgroundColor,
    required SingleSelectController<T>? controller,
    this.dividerColor,
    this.elevation,
    this.header,
    this.headerTitle,
    this.initialChildSize = 0.4,
    this.isThreeLine = false,
    this.itemTitle,
    this.maxChildSize = 1.0,
    this.minChildSize = 0.25,
    void Function(T?)? onConfirm,
    this.onSearchTextChanged,
    void Function(T?)? onSelectionChanged,
    this.searchable = false,
    this.searchBuilder,
    this.secondary,
    this.shape,
    this.subtitle,
  })  : multiselect = false,
        multiSelectController = null,
        onConfirmSingle = onConfirm,
        onConfirmMulti = null,
        onMultiSelectionChanged = null,
        onSingleSelectionChanged = onSelectionChanged,
        singleSelectController = controller;

  const SelectableListBottomSheet.multi({
    super.key,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.header,
    this.headerTitle,
    this.initialChildSize = 0.4,
    this.isThreeLine = false,
    this.itemTitle,
    this.maxChildSize = 1.0,
    this.minChildSize = 0.25,
    required MultiSelectController<T>? controller,
    this.dividerColor,
    void Function(List<T>)? onConfirm,
    this.onSearchTextChanged,
    OnMultiSelectionChanged onSelectionChanged,
    this.searchable = false,
    this.searchBuilder,
    this.secondary,
    this.shape,
    this.subtitle,
  })  : multiselect = true,
        multiSelectController = controller,
        onConfirmSingle = null,
        onConfirmMulti = onConfirm,
        onMultiSelectionChanged = onSelectionChanged,
        onSingleSelectionChanged = null,
        singleSelectController = null;

  @override
  State<SelectableListBottomSheet<T>> createState() =>
      _SelectableListBottomSheetState<T>();
}

class _SelectableListBottomSheetState<T>
    extends State<SelectableListBottomSheet<T>> with ModalDefaultsMixin<T> {
  // Stores the controller value when the dialog is opened (initState is invoked).
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
    BottomSheetThemeData bottomSheetTheme = Theme.of(context).bottomSheetTheme;
    final _BottomSheetDefaultsM3 defaults = _BottomSheetDefaultsM3(context);

    return DraggableScrollableSheet(
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Material(
          color:
              widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
          elevation: widget.elevation ??
              (widget.backgroundColor != null
                  ? 0
                  : bottomSheetTheme.elevation ?? 6),
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          shape: widget.shape ?? bottomSheetTheme.shape ?? defaults.shape,
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
                      ? SelectableList.multi(
                          backgroundColor: widget.backgroundColor,
                          controller: _controller as MultiSelectController<T>,
                          elevation: widget.elevation ?? 6,
                          isThreeLine: widget.isThreeLine,
                          // itemBuilder: widget.itemBuilder,
                          itemTitle: widget.itemTitle,
                          onSelectionChanged: widget.onMultiSelectionChanged,
                          secondary: widget.secondary,
                          subtitle: widget.subtitle,
                        )
                      : SelectableList.single(
                          backgroundColor: widget.backgroundColor,
                          controller: _controller as SingleSelectController<T>,
                          elevation: widget.elevation ?? 6,
                          // itemBuilder: widget.itemBuilder,
                          itemTitle: widget.itemTitle,
                          onSelectionChanged: widget.onSingleSelectionChanged,
                          secondary: widget.secondary,
                          subtitle: widget.subtitle,
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
        );
      },
    );
  }
}

class _BottomSheetDefaultsM3 {
  _BottomSheetDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  double get elevation => 6.0;
  ShapeBorder get shape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
      );
  double get modalElevation => 1.0;
  BoxConstraints get constraints => const BoxConstraints(maxWidth: 640);
  Color? get backgroundColor => _colors.surface;
  Color? get surfaceTintColor => _colors.surfaceTint;
  Color? get shadowColor => Colors.transparent;
  Color? get dragHandleColor => _colors.onSurfaceVariant.withOpacity(0.4);
  Size? get dragHandleSize => const Size(32, 4);
}
