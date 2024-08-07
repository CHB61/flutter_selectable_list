import 'package:flutter/material.dart';
import 'selectable_list_bottomsheet.dart';
import 'selectable_list_dialog.dart';
import 'modal/dropdown.dart';
import 'selectable_list_dropdown.dart';
import 'selectable_list.dart';
import 'selectable_list_side_sheet.dart';
import 'modal/side_sheet.dart';

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

  final Function? onBarrierDismissed;

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

  /// Enables the default search functionality. Has no effect when [header] is provided.
  final bool searchable;

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
    this.onBarrierDismissed,
    void Function(T?)? onConfirm,
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    void Function(T?)? onSelectionChanged,
    this.progressIndicator,
    this.resetOnBarrierDismissed = true,
    this.searchable = false,
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
    this.onBarrierDismissed,
    void Function(List<T>)? onConfirm,
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    OnMultiSelectionChanged onSelectionChanged,
    this.progressIndicator,
    this.resetOnBarrierDismissed = true,
    this.searchable = false,
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

  void _openBottomSheet() {
    List<T> originalValue = widget.multiselect
        ? [..._controller.value]
        : _controller.value != null
            ? [_controller.value]
            : [];

    showModalBottomSheet(
      // backgroundColor: widget.backgroundColor,
      barrierColor: widget.barrierColor,
      barrierLabel: widget.barrierLabel,
      isDismissible: widget.barrierDismissable,
      showDragHandle: widget.bottomSheetProperties.showDragHandle,
      // shape: widget.shape,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return widget.multiselect
            ? SelectableListBottomSheet.multi(
                // backgroundColor: widget.backgroundColor,
                controller: _controller as MultiSelectController<T>,
                // elevation: widget.elevation,
                initialChildSize: widget.bottomSheetProperties.initialChildSize,
                itemTitle: widget.itemTitle,
                maxChildSize: widget.bottomSheetProperties.maxChildSize,
                minChildSize: widget.bottomSheetProperties.minChildSize,
                // shape: widget.shape,
              )
            : SelectableListBottomSheet.single(
                // backgroundColor: widget.backgroundColor,
                controller: _controller as SingleSelectController<T>,
                // elevation: widget.elevation,
                itemTitle: widget.itemTitle,
              );
      },
    ).then((value) {
      // Handle barrier tap - will pop with null value.
      // Default confirm and cancel buttons always pop with a value.
      if (value == null) {
        widget.onBarrierDismissed?.call() ?? _resetValue(originalValue);
      }
    });
  }

  void _openDialog() {
    List<T> originalValue = widget.multiselect
        ? [..._controller.value]
        : _controller.value != null
            ? [_controller.value]
            : [];

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
        return widget.multiselect
            ? SelectableListDialog<T>.multi(
                actions: widget.actions,
                backgroundColor: widget.backgroundColor,
                controller: _controller as MultiSelectController<T>,
                dividerColor: widget.dividerColor,
                elevation: widget.elevation,
                header: widget.header,
                headerTitle: widget.headerTitle,
                isThreeLine: widget.isThreeLine,
                itemBuilder: widget.itemBuilder,
                itemTitle: widget.itemTitle,
                onConfirm: (values) {
                  _state?.didChange(values);
                  widget.onConfirmMulti?.call(values);
                },
                onMaxScrollExtent: widget.onMaxScrollExtent,
                onSearchTextChanged: widget.onSearchTextChanged,
                onSelectionChanged: (values, item, checked) {
                  _state?.didChange(values);
                  widget.onMultiSelectionChanged?.call(values, item, checked);
                },
                padding: widget.viewPadding,
                progressIndicator: widget.progressIndicator,
                searchViewBuilder: widget.searchViewBuilder,
                searchable: widget.searchable,
                secondary: widget.secondary,
                shape: widget.shape,
                subtitle: widget.subtitle,
              )
            : SelectableListDialog<T>.single(
                actions: widget.actions,
                backgroundColor: widget.backgroundColor,
                controller: _controller as SingleSelectController<T>,
                dividerColor: widget.dividerColor,
                elevation: widget.elevation,
                header: widget.header,
                headerTitle: widget.headerTitle,
                isThreeLine: widget.isThreeLine,
                itemBuilder: widget.itemBuilder,
                itemTitle: widget.itemTitle,
                onConfirm: (value) {
                  _state?.didChange(value);
                  widget.onConfirmSingle?.call(value);
                },
                onMaxScrollExtent: widget.onMaxScrollExtent,
                onSearchTextChanged: widget.onSearchTextChanged,
                onSelectionChanged: (value) {
                  _state?.didChange(value);
                  widget.onSingleSelectionChanged?.call(value);
                },
                padding: widget.viewPadding,
                progressIndicator: widget.progressIndicator,
                searchViewBuilder: widget.searchViewBuilder,
                searchable: widget.searchable,
                secondary: widget.secondary,
                shape: widget.shape,
                subtitle: widget.subtitle,
              );
      },
    ).then((value) {
      // Handle barrier tap - will pop with null value.
      // Default confirm and cancel buttons always pop with a value.
      if (value == null) {
        widget.onBarrierDismissed?.call() ?? _resetValue(originalValue);
      }
    });
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
      shape: widget.shape,
      width: widget.dropdownProperties.width,
      builder: (ctx) {
        return widget.multiselect
            ? SelectableListDropdown.multi(
                actions: widget.actions,
                backgroundColor: widget.backgroundColor,
                controller: _controller as MultiSelectController<T>,
                dividerColor: widget.dividerColor,
                elevation: widget.elevation,
                header: widget.header,
                headerTitle: widget.headerTitle,
                itemTitle: widget.itemTitle,
                isThreeLine: widget.isThreeLine,
                itemBuilder: widget.itemBuilder,
                onMaxScrollExtent: widget.onMaxScrollExtent,
                onSearchTextChanged: widget.onSearchTextChanged,
                onSelectionChanged: widget.onMultiSelectionChanged,
                padding: widget.viewPadding,
                progressIndicator: widget.progressIndicator,
                searchable: widget.searchable,
                searchViewBuilder: widget.searchViewBuilder,
                secondary: widget.secondary,
                subtitle: widget.subtitle,
                showDefaultHeader: widget.dropdownProperties.showDefaultHeader,
              )
            : SelectableListDropdown.single(
                actions: widget.actions,
                backgroundColor: widget.backgroundColor,
                controller: _controller as SingleSelectController<T>,
                dividerColor: widget.dividerColor,
                elevation: widget.elevation,
                header: widget.header,
                headerTitle: widget.headerTitle,
                itemTitle: widget.itemTitle,
                isThreeLine: widget.isThreeLine,
                itemBuilder: widget.itemBuilder,
                onMaxScrollExtent: widget.onMaxScrollExtent,
                onSearchTextChanged: widget.onSearchTextChanged,
                onSelectionChanged: widget.onSingleSelectionChanged,
                padding: widget.viewPadding,
                progressIndicator: widget.progressIndicator,
                searchable: widget.searchable,
                searchViewBuilder: widget.searchViewBuilder,
                secondary: widget.secondary,
                subtitle: widget.subtitle,
                showDefaultHeader: widget.dropdownProperties.showDefaultHeader,
              );
      },
    ).then((value) {
      // Handle barrier tap - will pop with null value.
      // Default confirm and cancel buttons always pop with a value.
      if (value == null) {
        widget.onBarrierDismissed?.call();
      }
    });
  }

  void _openSideSheet() {
    List<T> originalValue = widget.multiselect
        ? [..._controller.value]
        : _controller.value != null
            ? [_controller.value]
            : [];

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
        return widget.multiselect
            ? SelectableListSideSheet.multi(
                backgroundColor: widget.backgroundColor,
                actions: widget.actions,
                controller: _controller as MultiSelectController<T>,
                dividerColor: widget.dividerColor,
                elevation: widget.elevation,
                header: widget.header,
                headerTitle: widget.headerTitle,
                isThreeLine: widget.isThreeLine,
                itemBuilder: widget.itemBuilder,
                itemTitle: widget.itemTitle,
                onConfirm: (values) {
                  _state?.didChange(values);
                  widget.onConfirmMulti?.call(values);
                },
                onMaxScrollExtent: widget.onMaxScrollExtent,
                onSearchTextChanged: widget.onSearchTextChanged,
                onSelectionChanged: (values, item, checked) {
                  _state?.didChange(values);
                  widget.onMultiSelectionChanged?.call(values, item, checked);
                },
                padding: widget.viewPadding,
                progressIndicator: widget.progressIndicator,
                searchable: widget.searchable,
                searchViewBuilder: widget.searchViewBuilder,
                secondary: widget.secondary,
                subtitle: widget.subtitle,
                shape: widget.shape,
              )
            : SelectableListSideSheet.single(
                backgroundColor: widget.backgroundColor,
                actions: widget.actions,
                controller: _controller as SingleSelectController<T>,
                dividerColor: widget.dividerColor,
                elevation: widget.elevation,
                header: widget.header,
                headerTitle: widget.headerTitle,
                isThreeLine: widget.isThreeLine,
                itemBuilder: widget.itemBuilder,
                itemTitle: widget.itemTitle,
                onConfirm: (value) {
                  _state?.didChange(value);
                  widget.onConfirmSingle?.call(value);
                },
                onMaxScrollExtent: widget.onMaxScrollExtent,
                onSearchTextChanged: widget.onSearchTextChanged,
                onSelectionChanged: (value) {
                  _state?.didChange(value);
                  widget.onSingleSelectionChanged?.call(value);
                },
                padding: widget.viewPadding,
                progressIndicator: widget.progressIndicator,
                searchable: widget.searchable,
                searchViewBuilder: widget.searchViewBuilder,
                secondary: widget.secondary,
                subtitle: widget.subtitle,
                shape: widget.shape,
              );
      },
    ).then((value) {
      // Handle barrier tap - will pop with null value.
      // Default confirm and cancel buttons always pop with a value.
      if (value == null) {
        if (widget.resetOnBarrierDismissed) {
          _resetValue(originalValue);
        }
        widget.onBarrierDismissed?.call();
      }
    });
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

  const DialogProperties({
    this.transitionBuilder,
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

  const SideSheetProperties({
    this.axisAlignment,
    this.direction = TextDirection.ltr,
    this.transitionBuilder,
    this.width,
  });
}
