import 'package:flutter/material.dart';
import '../../selectable_list.dart';
import '../../selectable_list_anchor.dart';
import '../modal_defaults_mixin.dart';

class ListSelectBottomSheet<T> extends StatefulWidget {
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

  // final Widget Function(T)? itemTitle;
  final String Function(T)? itemTitle;

  final double minChildSize;
  final double maxChildSize;

  final bool multiselect;

  final SingleSelectController<T>? singleSelectController;
  final MultiSelectController<T>? multiSelectController;

  final void Function(T)? onConfirmSingle;
  final void Function(List<T>)? onConfirmMulti;

  final void Function(List<T>, T, bool)? onMultiSelectionChanged;
  final void Function(String)? onSearchTextChanged;
  final void Function(T?)? onSingleSelectionChanged;

  /// Enables the default search functionality. Has no effect when [header] is provided.
  final bool searchable;

  final Widget Function(TextEditingController, Widget)? searchBuilder;
  final Widget Function(T)? secondary;
  final Widget Function(T)? subtitle;
  final bool isThreeLine;

  final ShapeBorder? shape;

  const ListSelectBottomSheet.single({
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
    void Function(T)? onConfirm,
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

  const ListSelectBottomSheet.multi({
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
    void Function(List<T>, T, bool)? onSelectionChanged,
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
  State<ListSelectBottomSheet<T>> createState() =>
      _ListSelectBottomSheetState<T>();
}

class _ListSelectBottomSheetState<T> extends State<ListSelectBottomSheet<T>>
    with ModalDefaultsMixin<T> {
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
    final BottomSheetThemeData defaults = _BottomSheetDefaultsM3(context);

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
          shape: widget.shape ?? bottomSheetTheme.shape ?? defaults.shape!,
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
      },
    );
  }
}

class _BottomSheetDefaultsM3 extends BottomSheetThemeData {
  _BottomSheetDefaultsM3(this.context)
      : super(
          elevation: 1.0,
          modalElevation: 1.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.0))),
          constraints: const BoxConstraints(maxWidth: 640),
        );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color? get backgroundColor => _colors.surface;

  @override
  Color? get surfaceTintColor => _colors.surfaceTint;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get dragHandleColor => _colors.onSurfaceVariant.withOpacity(0.4);

  @override
  Size? get dragHandleSize => const Size(32, 4);

  @override
  BoxConstraints? get constraints => const BoxConstraints(maxWidth: 640.0);
}
