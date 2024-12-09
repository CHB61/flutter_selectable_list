import 'package:flutter/material.dart';
import 'modal/dropdown.dart';
import 'modal/side_sheet.dart';
import 'selectable_list.dart';

class SelectableListAnchor<T> extends StatefulWidget {
  const SelectableListAnchor.single({
    super.key,
    this.actions,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.backgroundColor,
    this.barrierColor = const Color(0x80000000),
    this.barrierDismissable = true,
    this.barrierLabel,
    required SelectableListAnchorBuilder<T> builder,
    this.bottomSheetProperties = const BottomSheetProperties(),
    SingleSelectController<T>? controller,
    this.dialogProperties = const DialogProperties(),
    this.dividerColor,
    this.dropdownProperties = const DropdownProperties(),
    this.elevation,
    this.enableDefaultSearch = false,
    this.floatSelectedValue = false,
    this.foregroundColor,
    this.formFieldKey,
    this.header,
    this.headerTitle,
    this.isThreeLine = false,
    this.itemBuilder,
    this.itemExtent,
    this.items,
    this.itemTitle,
    Function(T)? onBarrierDismissed,
    void Function(T?)? onConfirm,
    this.onScrollThresholdReached,
    this.onSearchTextChanged,
    void Function(T?)? onSelectionChanged,
    this.pinSelectedValue = false,
    this.progressIndicator,
    this.resetOnBarrierDismissed,
    this.scrollThreshold = 0.85,
    this.searchViewBuilder,
    this.secondary,
    this.shadowColor,
    this.shape,
    this.sideSheetProperties = const SideSheetProperties(),
    this.subtitle,
    this.surfaceTintColor,
    this.tileColor,
    FormFieldValidator<T>? validator,
    Widget Function(FormFieldState<T>)? validatorBuilder,
    this.viewPadding,
  })  : multiselect = false,
        multiSelectController = null,
        multiSelectBuilder = null,
        onBarrierDismissedMulti = null,
        onBarrierDismissedSingle = onBarrierDismissed,
        onConfirmMulti = null,
        onConfirmSingle = onConfirm,
        onMultiSelectionChanged = null,
        onSingleSelectionChanged = onSelectionChanged,
        singleSelectBuilder = builder,
        singleSelectController = controller,
        validatorMulti = null,
        validatorSingle = validator,
        validatorBuilderMulti = null,
        validatorBuilderSingle = validatorBuilder,
        assert(items == null || controller == null),
        assert(items != null || controller != null);

  const SelectableListAnchor.multi({
    super.key,
    this.actions,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.backgroundColor,
    this.barrierColor = const Color(0x80000000),
    this.barrierDismissable = true,
    this.barrierLabel,
    required SelectableListAnchorBuilder<List<T>> builder,
    this.bottomSheetProperties = const BottomSheetProperties(),
    MultiSelectController<T>? controller,
    this.dialogProperties = const DialogProperties(),
    this.dividerColor,
    this.dropdownProperties = const DropdownProperties(),
    this.elevation,
    this.enableDefaultSearch = false,
    this.floatSelectedValue = false,
    this.foregroundColor,
    this.formFieldKey,
    this.header,
    this.headerTitle,
    this.isThreeLine = false,
    this.itemBuilder,
    this.itemExtent,
    this.items,
    this.itemTitle,
    Function(List<T>)? onBarrierDismissed,
    void Function(List<T>)? onConfirm,
    this.onScrollThresholdReached,
    this.onSearchTextChanged,
    OnMultiSelectionChanged<T> onSelectionChanged,
    this.pinSelectedValue = false,
    this.progressIndicator,
    this.resetOnBarrierDismissed,
    this.scrollThreshold = 0.85,
    this.searchViewBuilder,
    this.secondary,
    this.shadowColor,
    this.shape,
    this.sideSheetProperties = const SideSheetProperties(),
    this.subtitle,
    this.surfaceTintColor,
    this.tileColor,
    FormFieldValidator<List<T>>? validator,
    Widget Function(FormFieldState<List<T>>)? validatorBuilder,
    this.viewPadding,
  })  : multiselect = true,
        multiSelectBuilder = builder,
        multiSelectController = controller,
        onBarrierDismissedMulti = onBarrierDismissed,
        onBarrierDismissedSingle = null,
        onConfirmMulti = onConfirm,
        onConfirmSingle = null,
        onMultiSelectionChanged = onSelectionChanged,
        onSingleSelectionChanged = null,
        singleSelectBuilder = null,
        singleSelectController = null,
        validatorMulti = validator,
        validatorSingle = null,
        validatorBuilderMulti = validatorBuilder,
        validatorBuilderSingle = null,
        assert(items == null || controller == null),
        assert(items != null || controller != null);

  final Widget? actions;
  final AutovalidateMode autovalidateMode;
  final Color? backgroundColor;
  final Color barrierColor;
  final bool barrierDismissable;
  final String? barrierLabel;
  final BottomSheetProperties bottomSheetProperties;

  final Color? dividerColor;

  final DropdownProperties dropdownProperties;
  final DialogProperties dialogProperties;

  final double? elevation;

  /// Enables the default header's search functionality.
  final bool enableDefaultSearch;

  final Key? formFieldKey;

  /// {@macro selectable_list_float_selected}
  final bool floatSelectedValue;

  final Color? foregroundColor;

  /// Replaces the default header of the view.
  final Widget? header;

  /// The default value is "Select" and the [TextStyle] uses [TextTheme.titleLarge].
  final String? headerTitle;

  /// Overrides the default [CheckboxListTile].
  /// {@macro selectable_list_item_builder}
  final Widget Function(T item, int index)? itemBuilder;

  /// {@macro selectable_list_item_extent}
  final double? itemExtent;

  final List<T>? items;
  final String Function(T)? itemTitle;

  /// Passed to the default [ListTile].
  final bool isThreeLine;

  final bool multiselect;
  final Widget Function(MultiSelectController<T>, FormFieldState<List<T>>)?
      multiSelectBuilder;
  final MultiSelectController<T>? multiSelectController;

  final Function(T originalValue)? onBarrierDismissedSingle;
  final Function(List<T> originalValue)? onBarrierDismissedMulti;

  final void Function(T?)? onConfirmSingle;
  final void Function(List<T>)? onConfirmMulti;

  /// Callback for when scroll extent is reached.
  final Function? onScrollThresholdReached;

  final OnMultiSelectionChanged<T> onMultiSelectionChanged;

  final void Function(String)? onSearchTextChanged;

  final void Function(T?)? onSingleSelectionChanged;

  final bool pinSelectedValue;

  // final FormFieldSetter<List<T>>? onSavedMulti;
  // final FormFieldSetter<T>? onSavedSingle;

  /// Widget to be displayed when [SelectableListController.loading] is `true`.
  /// The position of this widget can be set using the [SelectableListController.progressIndicatorPosition].
  final Widget? progressIndicator;

  final bool? resetOnBarrierDismissed;

  /// {@macro selectable_list_scroll_threshold}
  final double scrollThreshold;

  final Widget Function(TextEditingController, Widget)? searchViewBuilder;

  final Widget Function(T)? secondary;

  /// Defaults to Colors.transparent if not provided.
  final Color? shadowColor;

  final ShapeBorder? shape;

  final SideSheetProperties sideSheetProperties;

  final Widget Function(SingleSelectController<T>, FormFieldState<T>)?
      singleSelectBuilder;

  final SingleSelectController<T>? singleSelectController;

  /// Passed to the default [ListTile].
  final Widget Function(T)? subtitle;

  final Color? surfaceTintColor;

  /// The ListTile color of the default list item.
  final Color? tileColor;

  final FormFieldValidator<List<T>>? validatorMulti;
  final FormFieldValidator<T>? validatorSingle;

  final Widget Function(FormFieldState<T>)? validatorBuilderSingle;
  final Widget Function(FormFieldState<List<T>>)? validatorBuilderMulti;

  final EdgeInsetsGeometry? viewPadding;

  @override
  State<SelectableListAnchor<T>> createState() =>
      _SelectableListAnchorState<T>();
}

class _SelectableListAnchorState<T> extends State<SelectableListAnchor<T>> {
  final GlobalKey _anchorKey = GlobalKey();
  late final SelectableListController<T> _controller;
  FormFieldState? _state;
  List<T> _originalValue = [];

  @override
  void initState() {
    super.initState();

    widget.multiselect
        ? _controller = widget.multiSelectController ??
            MultiSelectController(
              items: widget.items,
            )
        : _controller = widget.singleSelectController ??
            SingleSelectController(
              items: widget.items,
            );

    _controller._anchor = this;
  }

  Widget _buildSelectableList({
    double? elevation,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? padding,
    ShapeBorder? shape,
    bool showDefaultActions = true,
    bool showDefaultHeader = true,
  }) {
    _SelectableListDefaultsM3 defaults = _SelectableListDefaultsM3(context);

    return Material(
      color: widget.backgroundColor,
      surfaceTintColor: widget.surfaceTintColor,
      elevation: widget.elevation ?? defaults.elevation,
      shadowColor: widget.shadowColor,
      shape: widget.shape ?? shape ?? defaults.shape,
      child: Padding(
        padding: widget.viewPadding ?? padding ?? defaults.padding,
        child: Column(
          children: [
            widget.header ??
                (showDefaultHeader
                    ? _DefaultHeader(
                        controller: _controller,
                        foregroundColor: widget.foregroundColor,
                        itemTitle: widget.itemTitle,
                        onSearchTextChanged: widget.onSearchTextChanged,
                        padding: headerPadding,
                        enableDefaultSearch: widget.enableDefaultSearch,
                        title: widget.headerTitle,
                      )
                    : Container()),
            if (widget.header != null || showDefaultHeader)
              Divider(
                height: 1,
                color: widget.dividerColor,
              ),
            Expanded(
              child: widget.multiselect
                  ? SelectableList<T>.multi(
                      controller: _controller as MultiSelectController<T>,
                      dividerColor: widget.dividerColor,
                      elevation: elevation ?? defaults.elevation,
                      foregroundColor: widget.foregroundColor,
                      floatSelectedValue: widget.floatSelectedValue,
                      isThreeLine: widget.isThreeLine,
                      itemBuilder: widget.itemBuilder,
                      itemExtent: widget.itemExtent,
                      itemTitle: widget.itemTitle,
                      onScrollThresholdReached: widget.onScrollThresholdReached,
                      onSearchTextChanged: widget.onSearchTextChanged,
                      onSelectionChanged: (values, item, checked) {
                        _state?.didChange(values);
                        widget.onMultiSelectionChanged
                            ?.call(values, item, checked);
                      },
                      pinSelectedValue: widget.pinSelectedValue,
                      progressIndicator: widget.progressIndicator,
                      scrollThreshold: widget.scrollThreshold,
                      searchViewBuilder: widget.searchViewBuilder,
                      secondary: widget.secondary,
                      subtitle: widget.subtitle,
                      surfaceTintColor: widget.surfaceTintColor,
                      tileColor: widget.tileColor ?? widget.backgroundColor,
                    )
                  : SelectableList<T>.single(
                      tileColor: widget.tileColor ?? widget.backgroundColor,
                      controller: _controller as SingleSelectController<T>,
                      dividerColor: widget.dividerColor,
                      elevation: elevation ?? defaults.elevation,
                      floatSelectedValue: widget.floatSelectedValue,
                      foregroundColor: widget.foregroundColor,
                      isThreeLine: widget.isThreeLine,
                      itemBuilder: widget.itemBuilder,
                      itemExtent: widget.itemExtent,
                      itemTitle: widget.itemTitle,
                      onScrollThresholdReached: widget.onScrollThresholdReached,
                      onSearchTextChanged: widget.onSearchTextChanged,
                      onSelectionChanged: (value) {
                        _state?.didChange(value);
                        widget.onSingleSelectionChanged?.call(value);
                      },
                      pinSelectedValue: widget.pinSelectedValue,
                      progressIndicator: widget.progressIndicator,
                      scrollThreshold: widget.scrollThreshold,
                      searchViewBuilder: widget.searchViewBuilder,
                      secondary: widget.secondary,
                      subtitle: widget.subtitle,
                      surfaceTintColor: widget.surfaceTintColor,
                    ),
            ),
            if (widget.actions != null || showDefaultActions)
              Divider(
                height: 1,
                color: widget.dividerColor,
              ),
            widget.actions ??
                (showDefaultActions
                    ? _DefaultActions(
                        controller: _controller,
                        multiselect: widget.multiselect,
                        originalValue: _originalValue,
                        onConfirm: () {
                          {
                            final value = _controller.value;
                            _state?.didChange(value);
                            widget.multiselect
                                ? widget.onConfirmMulti?.call(value as List<T>)
                                : widget.onConfirmSingle?.call(value as T?);
                          }
                        },
                      )
                    : Container()),
          ],
        ),
      ),
    );
  }

  void _openBottomSheet() {
    _SelectableListDefaultsM3 defaults = _SelectableListDefaultsM3(context);
    BottomSheetThemeData bottomSheetTheme = Theme.of(context).bottomSheetTheme;
    double? elevation =
        widget.elevation ?? bottomSheetTheme.elevation ?? defaults.elevation;
    ShapeBorder shape = bottomSheetTheme.shape ?? defaults.bottomSheetShape;

    _cacheOriginalValue();

    showModalBottomSheet(
      // backgroundColor: widget.backgroundColor,
      // elevation: elevation,
      barrierColor: widget.barrierColor,
      barrierLabel: widget.barrierLabel,
      isDismissible: widget.barrierDismissable,
      showDragHandle: widget.bottomSheetProperties.showDragHandle,
      shape: widget.shape ?? shape,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: widget.bottomSheetProperties.initialChildSize,
          minChildSize: widget.bottomSheetProperties.minChildSize,
          maxChildSize: widget.bottomSheetProperties.maxChildSize,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return _buildSelectableList(
                elevation: elevation,
                showDefaultActions: true,
                shape: shape,
                padding: const EdgeInsets.all(12.0));
          },
        );
      },
    ).then((value) => value == null ? _handleBarrierDismissed(value) : null);
  }

  void _openDialog() {
    _cacheOriginalValue();

    showGeneralDialog(
      context: context,
      barrierColor: widget.barrierColor,
      barrierDismissible: widget.barrierDismissable,
      barrierLabel: widget.barrierLabel ?? '',
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: widget.dialogProperties.transitionBuilder ??
          (context, animation, _, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.linear,
              ),
              child: child,
            );
          },
      pageBuilder: (ctx, animation, _) {
        _SelectableListDefaultsM3 defaults = _SelectableListDefaultsM3(context);

        return Dialog(
          backgroundColor: widget.backgroundColor,
          elevation: widget.elevation ?? defaults.elevation,
          shape: widget.shape,
          // shadowColor: widget.shadowColor ?? defaults.shadowColor,
          surfaceTintColor: widget.surfaceTintColor ?? Colors.transparent,
          child: SizedBox(
            height: widget.dialogProperties.height ??
                MediaQuery.of(context).size.height * 0.7,
            width: widget.dialogProperties.width ??
                MediaQuery.of(context).size.width * 0.7,
            child: _buildSelectableList(
              showDefaultActions: true,
            ),
          ),
        );
      },
    ).then((value) => value == null ? _handleBarrierDismissed(value) : null);
  }

  void _openDropdown() {
    _cacheOriginalValue();

    showModalDropdown(
      alignment: widget.dropdownProperties.alignment,
      anchorKey: widget.dropdownProperties.anchor ? _anchorKey : null,
      backgroundColor: widget.backgroundColor,
      barrierColor: widget.barrierColor,
      barrierDismissible: widget.barrierDismissable,
      barrierLabel: widget.barrierLabel,
      context: context,
      constraints: widget.dropdownProperties.constraints,
      elevation: widget.elevation,
      offset: widget.dropdownProperties.offset,
      width: widget.dropdownProperties.width,
      builder: (ctx) {
        return _buildSelectableList(
          elevation: widget.elevation,
          headerPadding: const EdgeInsets.fromLTRB(12, 8, 8, 0),
          padding: EdgeInsets.zero,
          showDefaultActions: false,
          showDefaultHeader: false,
        );
      },
    ).then((value) =>
        value == null ? _handleBarrierDismissed(value, false) : null);
  }

  void _openSideSheet() {
    _cacheOriginalValue();

    showModalSideSheet(
      axisAlignment: widget.sideSheetProperties.axisAlignment,
      barrierColor: widget.barrierColor,
      barrierDismissible: widget.barrierDismissable,
      barrierLabel: widget.barrierLabel,
      context: context,
      direction: widget.sideSheetProperties.direction,
      transitionBuilder: widget.sideSheetProperties.transitionBuilder,
      width: widget.sideSheetProperties.width,
      builder: (ctx) {
        return Padding(
          padding: widget.sideSheetProperties.insetPadding,
          child: Padding(
            padding: widget.viewPadding ??
                EdgeInsets.zero, // ?? const EdgeInsets.all(24),
            child: _buildSelectableList(
              elevation: widget.elevation,
            ),
          ),
        );
      },
    ).then((value) => value == null ? _handleBarrierDismissed(value) : null);
  }

  _cacheOriginalValue() {
    _originalValue = widget.multiselect
        ? [..._controller.value]
        : _controller.value != null
            ? [_controller.value]
            : [];
  }

  // Called when the barrier is dismissed to reset the controller.value.
  // Dropdown is an exception since it doesn't have default `actions`, therefore
  // tapping the barrier is not considered a 'cancel' action.
  void _resetValue(List<T> originalValue) {
    if (_controller is MultiSelectController) {
      (_controller as MultiSelectController<T>).value = originalValue;
    } else {
      (_controller as SingleSelectController<T>).value =
          originalValue.isNotEmpty ? originalValue.first : null;
    }
    _state?.didChange(_controller.value);
  }

  void _handleBarrierDismissed(
    dynamic value, [
    bool resetOnBarrierDismissed = true,
  ]) {
    if (widget.resetOnBarrierDismissed ?? resetOnBarrierDismissed) {
      _resetValue(_originalValue);
    }

    widget.multiselect
        ? widget.onBarrierDismissedMulti?.call(value)
        : widget.onBarrierDismissedSingle?.call(value);
  }

  Widget _buildFormField(Widget field, FormFieldState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        field,
        _buildValidation(state),
      ],
    );
  }

  Widget _buildValidation(FormFieldState state) {
    if (widget.multiselect) {
      if (widget.validatorBuilderMulti != null) {
        return widget.validatorBuilderMulti!(state as FormFieldState<List<T>>);
      }
    } else {
      if (widget.validatorBuilderSingle != null) {
        return widget.validatorBuilderSingle!(state as FormFieldState<T>);
      }
    }

    return state.hasError
        ? Text(
            state.errorText ?? "",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _anchorKey,
      child: widget.multiselect
          ? FormField<List<T>>(
              autovalidateMode: widget.autovalidateMode,
              // initialValue: widget.initialValueList,
              key: widget.formFieldKey,
              // onSaved: widget.onSavedMulti,
              validator: widget.validatorMulti,
              builder: (state) {
                _state ??= state;
                Widget field = widget.multiSelectBuilder!(
                  _controller as MultiSelectController<T>,
                  state,
                );
                return _buildFormField(field, state);
              },
            )
          : FormField<T>(
              autovalidateMode: widget.autovalidateMode,
              // initialValue: widget.initialValueSingle,
              key: widget.formFieldKey,
              // onSaved: widget.onSavedSingle,
              validator: widget.validatorSingle,
              builder: (state) {
                _state ??= state;
                Widget field = widget.singleSelectBuilder!(
                  _controller as SingleSelectController<T>,
                  state,
                );
                return _buildFormField(field, state);
              },
            ),
    );
  }
}

class _DefaultHeader<T> extends StatefulWidget {
  final SelectableListController<T> controller;
  final Color? foregroundColor;
  final String Function(T)? itemTitle;
  final void Function(String)? onSearchTextChanged;
  final EdgeInsetsGeometry? padding;
  final bool enableDefaultSearch;
  final String? title;

  const _DefaultHeader({
    super.key,
    required this.controller,
    this.foregroundColor,
    this.itemTitle,
    this.onSearchTextChanged,
    this.padding,
    this.enableDefaultSearch = false,
    this.title,
  });

  @override
  State<_DefaultHeader<T>> createState() => __DefaultHeaderState<T>();
}

class __DefaultHeaderState<T> extends State<_DefaultHeader<T>> {
  final FocusNode _focusNode = FocusNode();

  void _search(String text) {
    List<T> filteredItems = [];

    filteredItems = widget.controller.items.where((e) {
      String name = widget.itemTitle?.call(e) ?? e.toString();
      return name.toLowerCase().contains(text.toLowerCase());
    }).toList();

    widget.controller.setFilteredItems(filteredItems);
  }

  @override
  Widget build(BuildContext context) {
    Color foregroundColor =
        widget.foregroundColor ?? Theme.of(context).colorScheme.onSurface;

    return ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          return Padding(
            padding: widget.padding ?? const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: widget.controller.searchActive
                ? TextField(
                    controller: widget.controller.searchController,
                    focusNode: _focusNode,
                    onChanged: widget.onSearchTextChanged ?? _search,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      contentPadding: const EdgeInsets.only(top: 12),
                      // widget.hintStyle ??
                      hintStyle: TextStyle(
                        color: foregroundColor.withAlpha(100),
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                      prefixIcon: IconButton(
                        onPressed: () {
                          widget.controller.setSearchValue("");
                          widget.controller.setFilteredItems(null, false);
                          widget.controller.setSearchActive(false);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: foregroundColor,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          widget.controller.setSearchValue("");
                          widget.controller.setFilteredItems(null);
                        },
                        icon: Icon(
                          Icons.close,
                          color: foregroundColor,
                        ),
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.title ?? "Select",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: foregroundColor,
                                ),
                          ),
                        ),
                        widget.enableDefaultSearch
                            ? IconButton(
                                onPressed: () {
                                  widget.controller.setSearchActive(true);
                                  _focusNode.requestFocus();
                                },
                                icon: Icon(
                                  Icons.search,
                                  color: foregroundColor,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
          );
        });
  }
}

class _DefaultActions<T> extends StatelessWidget {
  final SelectableListController<T> controller;
  final List<T> originalValue;
  final Function onConfirm;
  final bool multiselect;

  const _DefaultActions({
    super.key,
    required this.controller,
    required this.multiselect,
    required this.originalValue,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: OverflowBar(
        spacing: 8,
        alignment: MainAxisAlignment.end,
        // alignment: actionsAlignment ?? MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              if (controller is MultiSelectController) {
                (controller as MultiSelectController<T>).value = originalValue;
              } else {
                (controller as SingleSelectController<T>).value =
                    originalValue.isNotEmpty ? originalValue.first : null;
              }
              Navigator.pop(context, originalValue);
            },
            child: const Text("CANCEL"),
            // child: cancelText ?? const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              // If single select confirmed with no value, return empty list
              // so it doesn't get mistaken for a barrier dismissal which is
              // represented by a `null` value and results in the value being
              // reset if `resetOnBarrierDismissed` is true.
              if (!multiselect && controller.value == null) {
                Navigator.pop(context, []);
              } else {
                Navigator.pop(context, controller.value);
              }
              onConfirm();
            },
            child: const Text('OK'),
            // child: confirmText ?? const Text("OK"),
          )
        ],
      ),
    );
  }
}

/// A [ChangeNotifier] that maintains the state of the SelectableList.
abstract class SelectableListController<T> extends ChangeNotifier {
  _SelectableListAnchorState? _anchor;
  List<T> _items;
  List<T>? _filteredItems;
  bool _loading = false;
  bool _searchActive = false;
  ProgressIndicatorPosition progressIndicatorPosition =
      ProgressIndicatorPosition.center;

  /// Gets passed to the default search TextField, and to the `searchViewBuilder`
  /// callback of SelectableList.
  final TextEditingController _searchController;

  SelectableListController({
    List<T>? items,
    TextEditingController? searchController,
  })  : _items = items ?? [],
        _searchController = searchController ?? TextEditingController();

  List<T> get items => [..._items];
  List<T>? get filteredItems =>
      _filteredItems != null ? [..._filteredItems!] : null;
  bool get loading => _loading;
  bool get searchActive => _searchActive;
  TextEditingController get searchController => _searchController;

  void openDialog() {
    _anchor?._openDialog();
  }

  void openBottomSheet() {
    _anchor?._openBottomSheet();
  }

  void openSideSheet() {
    _anchor?._openSideSheet();
  }

  void openDropdown() {
    _anchor?._openDropdown();
  }

  void setItems(List<T> items, [bool notify = true]) {
    _items = [...items];
    if (notify) notifyListeners();
  }

  void setFilteredItems(List<T>? filteredItems, [bool notify = true]) {
    _filteredItems = filteredItems != null ? [...filteredItems] : null;
    if (notify) notifyListeners();
  }

  void setSearchActive(bool val, [bool notify = true]) {
    _searchActive = val;
    if (notify) notifyListeners();
  }

  void setSearchValue(String val, [bool notify = false]) {
    searchController.text = val;
    if (notify) notifyListeners();
  }

  void setLoading(bool isLoading, [bool notify = false]) {
    _loading = isLoading;
    if (notify) notifyListeners();
  }

  dynamic get value;
  set value(dynamic newValue);
  void onValueChanged(T item, [bool checked = true]);
  bool isItemChecked(T item);
}

class SingleSelectController<T> extends SelectableListController<T> {
  SingleSelectController({
    T? initialValue,
    super.items,
    super.searchController,
  }) : _value = initialValue;

  T? _value;

  @override
  T? get value => _value;

  @override
  set value(dynamic newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  @override
  void onValueChanged(T item, [bool checked = true]) {
    if (checked) {
      value = item;
    } else {
      value = null;
    }
  }

  @override
  bool isItemChecked(T item) {
    return value == item;
  }
}

class MultiSelectController<T> extends SelectableListController<T> {
  MultiSelectController({
    List<T>? initialValue,
    super.items,
    super.searchController,
  }) : _value = initialValue ?? [];

  List<T> _value;

  @override
  List<T> get value => _value;

  @override
  set value(dynamic newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  void removeItem(T item) {
    _value.remove(item);
    notifyListeners();
  }

  void toggleSelectAll(bool selectAll) {
    if (selectAll) {
      _value = items;
    } else {
      _value.clear();
    }
    notifyListeners();
  }

  @override
  void onValueChanged(T item, [bool checked = true]) {
    if (checked) {
      value.add(item);
    } else {
      value.remove(item);
    }
    notifyListeners();
  }

  @override
  bool isItemChecked(T item) {
    return value.contains(item);
  }
}

class BottomSheetProperties {
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  final bool? showDragHandle;

  const BottomSheetProperties({
    this.initialChildSize = 0.4,
    this.maxChildSize = 1.0,
    this.minChildSize = 0.25,
    this.showDragHandle,
  });
}

class DialogProperties {
  final RouteTransitionsBuilder? transitionBuilder;
  final double? height;
  final double? width;

  const DialogProperties({
    this.transitionBuilder,
    this.height,
    this.width,
  });
}

class DropdownProperties {
  final DropdownAligmnent alignment;

  /// Determines whether the `anchorKey` will be passed to `showDropdown`.
  final bool anchor;
  final BoxConstraints? constraints;

  /// Applied to the starting position of the dropdown.
  final Offset? offset;

  final double? width;

  const DropdownProperties({
    this.alignment = DropdownAligmnent.center,
    this.anchor = true,
    this.constraints,
    this.offset,
    this.width,
  });
}

class SideSheetProperties {
  final double? axisAlignment;
  final TextDirection direction;
  final RouteTransitionsBuilder? transitionBuilder;
  final double? width;
  final EdgeInsetsGeometry insetPadding;

  const SideSheetProperties({
    this.axisAlignment,
    this.direction = TextDirection.ltr,
    this.insetPadding = const EdgeInsets.all(8),
    this.transitionBuilder,
    this.width,
  });
}

class _SelectableListDefaultsM3 {
  _SelectableListDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  Alignment get alignment => Alignment.center;
  double get elevation => 6.0;
  ShapeBorder bottomSheetShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
    topLeft: Radius.circular(28),
    topRight: Radius.circular(28),
  ));
  ShapeBorder get shape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
      );
  Color? get backgroundColor => _colors.surface;
  Color? get shadowColor => Colors.transparent;
  Color? get surfaceTintColor => Colors.transparent;
  TextStyle? get titleTextStyle => _textTheme.headlineSmall;
  TextStyle? get contentTextStyle => _textTheme.bodyMedium;
  EdgeInsetsGeometry get actionsPadding =>
      const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0);
  EdgeInsetsGeometry get padding => const EdgeInsets.all(24.0);
}

typedef SelectableListAnchorBuilder<T> = Widget Function(
  SelectableListController controller,
  FormFieldState<T> formFieldState,
);
