import 'package:flutter/material.dart';
import 'modal/dropdown.dart';
import 'modal/side_sheet.dart';
import 'selectable_list.dart';

class SelectableListAnchor<T> extends StatefulWidget {
  final Widget? actions;
  final AutovalidateMode autovalidateMode;
  final Color? backgroundColor;
  final Color barrierColor;
  final bool barrierDismissable;
  final String? barrierLabel;

  final Color? dividerColor;

  final double? elevation;

  final Key? formFieldKey;

  /// Replaces the default header of the view.
  final Widget? header;

  /// The default value is "Select" and the [TextStyle] uses [TextTheme.titleLarge].
  final String? headerTitle;

  /// Overrides the default [CheckboxListTile].
  final Widget Function(T item, int index)? itemBuilder;

  final List<T>? items;
  final String Function(T)? itemTitle;

  final bool multiselect;
  final Widget Function(MultiSelectController<T>, FormFieldState<List<T>>)?
      multiSelectBuilder;
  final MultiSelectController<T>? multiSelectController;

  final Function(T originalValue)? onBarrierDismissedSingle;
  final Function(List<T> originalValue)? onBarrierDismissedMulti;

  final void Function(T?)? onConfirmSingle;
  final void Function(List<T>)? onConfirmMulti;

  /// Callback for when scroll extent is reached.
  final Function? onMaxScrollExtent;

  final OnMultiSelectionChanged onMultiSelectionChanged;

  final void Function(String)? onSearchTextChanged;

  final void Function(T?)? onSingleSelectionChanged;

  final FormFieldValidator<List<T>>? multiValidator;
  // final FormFieldSetter<List<T>>? onSavedMulti;
  // final FormFieldSetter<T>? onSavedSingle;

  /// Widget to be displayed when [SelectableListController.loading] is `true`.
  /// The position of this widget can be set using the [SelectableListController.progressIndicatorPosition].
  final Widget? progressIndicator;

  final bool resetOnBarrierDismissed;

  /// Enables the default header's search functionality.
  final bool showSearchField;

  final Widget Function(TextEditingController, Widget)? searchViewBuilder;

  final Widget Function(T)? secondary;

  final ShapeBorder? shape;

  final SideSheetProperties sideSheetProperties;

  final Widget Function(SingleSelectController<T>, FormFieldState<T>)?
      singleSelectBuilder;

  final SingleSelectController<T>? singleSelectController;

  final FormFieldValidator<T>? singleValidator;

  /// Passed to the default [ListTile].
  final Widget Function(T)? subtitle;

  /// Passed to the default [ListTile].
  final bool isThreeLine;

  final BottomSheetProperties bottomSheetProperties;
  final DropdownProperties dropdownProperties;
  final DialogProperties dialogProperties;

  final EdgeInsetsGeometry? viewPadding;

  const SelectableListAnchor.single({
    super.key,
    this.actions,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.backgroundColor,
    this.barrierColor = const Color(0x80000000),
    this.barrierDismissable = true,
    this.barrierLabel,
    required Widget Function(
      SelectableListController,
      FormFieldState<T>,
    ) builder,
    this.bottomSheetProperties = const BottomSheetProperties(),
    SingleSelectController<T>? controller,
    this.dialogProperties = const DialogProperties(),
    this.dividerColor,
    this.dropdownProperties = const DropdownProperties(),
    this.elevation,
    this.formFieldKey,
    this.header,
    this.headerTitle,
    this.isThreeLine = false,
    this.itemBuilder,
    this.items,
    this.itemTitle,
    Function(T)? onBarrierDismissed,
    void Function(T?)? onConfirm,
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    void Function(T?)? onSelectionChanged,
    this.progressIndicator,
    this.resetOnBarrierDismissed = false,
    this.showSearchField = false,
    this.searchViewBuilder,
    this.secondary,
    this.shape,
    this.sideSheetProperties = const SideSheetProperties(),
    this.subtitle,
    FormFieldValidator<T>? validator,
    this.viewPadding,
  })  : multiselect = false,
        multiSelectController = null,
        multiSelectBuilder = null,
        multiValidator = null,
        onBarrierDismissedMulti = null,
        onBarrierDismissedSingle = onBarrierDismissed,
        onConfirmMulti = null,
        onConfirmSingle = onConfirm,
        onMultiSelectionChanged = null,
        onSingleSelectionChanged = onSelectionChanged,
        singleSelectBuilder = builder,
        singleSelectController = controller,
        singleValidator = validator,
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
    required Widget Function(
      SelectableListController,
      FormFieldState<List<T>>,
    ) builder,
    this.bottomSheetProperties = const BottomSheetProperties(),
    MultiSelectController<T>? controller,
    this.dialogProperties = const DialogProperties(),
    this.dividerColor,
    this.dropdownProperties = const DropdownProperties(),
    this.elevation,
    this.formFieldKey,
    this.header,
    this.headerTitle,
    this.isThreeLine = false,
    this.itemBuilder,
    this.items,
    this.itemTitle,
    Function(List<T>)? onBarrierDismissed,
    void Function(List<T>)? onConfirm,
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    OnMultiSelectionChanged onSelectionChanged,
    this.progressIndicator,
    this.resetOnBarrierDismissed = false,
    this.showSearchField = false,
    this.searchViewBuilder,
    this.secondary,
    this.shape,
    this.sideSheetProperties = const SideSheetProperties(),
    this.subtitle,
    this.viewPadding,
    FormFieldValidator<List<T>>? validator,
  })  : multiselect = true,
        multiSelectBuilder = builder,
        multiSelectController = controller,
        multiValidator = validator,
        onBarrierDismissedMulti = onBarrierDismissed,
        onBarrierDismissedSingle = null,
        onConfirmMulti = onConfirm,
        onConfirmSingle = null,
        onMultiSelectionChanged = onSelectionChanged,
        onSingleSelectionChanged = null,
        singleSelectBuilder = null,
        singleSelectController = null,
        singleValidator = null,
        assert(items == null || controller == null),
        assert(items != null || controller != null);

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
    bool showDefaultActions = true,
    bool showDefaultHeader = true,
  }) {
    _SelectableListDefaultsM3 defaults = _SelectableListDefaultsM3(context);

    _originalValue = widget.multiselect
        ? [..._controller.value]
        : _controller.value != null
            ? [_controller.value]
            : [];

    return Column(
      children: [
        Expanded(
          child: widget.multiselect
              ? SelectableList<T>.multi(
                  backgroundColor: widget.backgroundColor,
                  controller: _controller as MultiSelectController<T>,
                  dividerColor: widget.dividerColor,
                  elevation: elevation ?? defaults.elevation,
                  header: widget.header,
                  headerPadding: headerPadding,
                  headerTitle: widget.headerTitle,
                  isThreeLine: widget.isThreeLine,
                  itemBuilder: widget.itemBuilder,
                  itemTitle: widget.itemTitle,
                  onScrollThresholdReached: widget.onMaxScrollExtent,
                  onSearchTextChanged: widget.onSearchTextChanged,
                  onSelectionChanged: (values, item, checked) {
                    _state?.didChange(values);
                    widget.onMultiSelectionChanged?.call(values, item, checked);
                  },
                  progressIndicator: widget.progressIndicator,
                  searchViewBuilder: widget.searchViewBuilder,
                  showSearchField: widget.showSearchField,
                  secondary: widget.secondary,
                  // shape: widget.shape,
                  showDefaultHeader: showDefaultHeader,
                  subtitle: widget.subtitle,
                )
              : SelectableList<T>.single(
                  backgroundColor: widget.backgroundColor,
                  controller: _controller as SingleSelectController<T>,
                  dividerColor: widget.dividerColor,
                  elevation: elevation ?? defaults.elevation,
                  header: widget.header,
                  headerPadding: headerPadding,
                  headerTitle: widget.headerTitle,
                  isThreeLine: widget.isThreeLine,
                  itemBuilder: widget.itemBuilder,
                  itemTitle: widget.itemTitle,
                  onScrollThresholdReached: widget.onMaxScrollExtent,
                  onSearchTextChanged: widget.onSearchTextChanged,
                  onSelectionChanged: (value) {
                    _state?.didChange(value);
                    widget.onSingleSelectionChanged?.call(value);
                  },
                  progressIndicator: widget.progressIndicator,
                  searchViewBuilder: widget.searchViewBuilder,
                  showSearchField: widget.showSearchField,
                  secondary: widget.secondary,
                  // shape: widget.shape,
                  showDefaultHeader: showDefaultHeader,
                  subtitle: widget.subtitle,
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
                    onConfirm: (value) {
                      {
                        _state?.didChange(value);
                        widget.multiselect
                            ? widget.onConfirmMulti?.call(value as List<T>)
                            : widget.onConfirmSingle?.call(value as T);
                      }
                    },
                  )
                : Container()),
      ],
    );
  }

  void _openBottomSheet() {
    BottomSheetThemeData bottomSheetTheme = Theme.of(context).bottomSheetTheme;
    double? elevation = widget.elevation ?? bottomSheetTheme.elevation;

    showModalBottomSheet(
      backgroundColor: widget.backgroundColor,
      elevation: elevation,
      barrierColor: widget.barrierColor,
      barrierLabel: widget.barrierLabel,
      isDismissible: widget.barrierDismissable,
      showDragHandle: widget.bottomSheetProperties.showDragHandle,
      // shape: widget.shape,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: widget.bottomSheetProperties.initialChildSize,
          minChildSize: widget.bottomSheetProperties.minChildSize,
          maxChildSize: widget.bottomSheetProperties.maxChildSize,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Padding(
              padding: widget.viewPadding ?? const EdgeInsets.all(24),
              child: _buildSelectableList(
                elevation: elevation,
                showDefaultActions: true,
              ),
            );
          },
        );
      },
    ).then((value) => value == null ? _handleBarrierDismissed(value) : null);
  }

  void _openDialog() {
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
        DialogTheme dialogTheme = Theme.of(context).dialogTheme;
        double? elevation = widget.elevation ?? dialogTheme.elevation;

        return Dialog(
          backgroundColor: widget.backgroundColor,
          elevation: elevation,
          shape: widget.shape,
          surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
          child: Padding(
            padding: widget.viewPadding ?? const EdgeInsets.all(24),
            child: SizedBox(
              height: widget.dialogProperties.height ??
                  MediaQuery.of(context).size.height * 0.7,
              width: widget.dialogProperties.width ??
                  MediaQuery.of(context).size.width * 0.7,
              child: _buildSelectableList(
                elevation: elevation,
                showDefaultActions: true,
              ),
            ),
          ),
        );
      },
    ).then((value) => value == null ? _handleBarrierDismissed(value) : null);
  }

  void _openDropdown() {
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
          showDefaultActions: false,
          showDefaultHeader: widget.dropdownProperties.showDefaultHeader,
          headerPadding: const EdgeInsets.fromLTRB(12, 4, 8, 0),
        );
      },
    ).then((value) => value == null ? _handleBarrierDismissed(value) : null);
  }

  void _openSideSheet() {
    _SelectableListDefaultsM3 defaults = _SelectableListDefaultsM3(context);

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
          child: Material(
            elevation: widget.elevation ?? defaults.elevation,
            clipBehavior: Clip.hardEdge,
            color: widget.backgroundColor,
            surfaceTintColor: defaults.surfaceTintColor,
            shape: widget.shape ?? defaults.shape,
            child: Padding(
              padding: widget.viewPadding ?? const EdgeInsets.all(24),
              child: _buildSelectableList(elevation: widget.elevation),
            ),
          ),
        );
      },
    ).then((value) => value == null ? _handleBarrierDismissed(value) : null);
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
  }

  void _handleBarrierDismissed(dynamic value) {
    if (widget.resetOnBarrierDismissed) {
      _resetValue(_originalValue);
    }

    widget.multiselect
        ? widget.onBarrierDismissedMulti?.call(value)
        : widget.onBarrierDismissedSingle?.call(value);
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
              validator: widget.multiValidator,
              builder: (state) {
                _state ??= state;
                return widget.multiSelectBuilder!(
                  _controller as MultiSelectController<T>,
                  state,
                );
                // return Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     widget.multiSelectBuilder!(
                //       _controller as MultiSelectController<T>,
                //       state,
                //     ),
                //     state.hasError
                //         ? Text(
                //             state.errorText ?? "",
                //             style: const TextStyle(
                //                 color: Colors.red, fontSize: 12),
                //           )
                //         : const Text(''),
                //   ],
                // );
              },
            )
          : FormField<T>(
              autovalidateMode: widget.autovalidateMode,
              // initialValue: widget.initialValueSingle,
              key: widget.formFieldKey,
              // onSaved: widget.onSavedSingle,
              validator: widget.singleValidator,
              builder: (state) {
                _state ??= state;
                return widget.singleSelectBuilder!(
                  _controller as SingleSelectController<T>,
                  state,
                );
              },
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

  final bool showDefaultHeader;
  final double? width;

  const DropdownProperties({
    this.alignment = DropdownAligmnent.center,
    this.anchor = true,
    this.constraints,
    this.offset,
    this.showDefaultHeader = false,
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
  ShapeBorder get shape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28.0)),
      );
  Color? get backgroundColor => _colors.surface;
  Color? get shadowColor => Colors.transparent;
  Color? get surfaceTintColor => _colors.surfaceTint;
  TextStyle? get titleTextStyle => _textTheme.headlineSmall;
  TextStyle? get contentTextStyle => _textTheme.bodyMedium;
  EdgeInsetsGeometry? get actionsPadding =>
      const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0);
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
              // reset.
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
