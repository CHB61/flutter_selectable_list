import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/modals/bottom_sheet/list_select_bottomsheet.dart';
import 'package:flutter_selectable_list/modals/dialog/list_select_dialog.dart';
import 'package:flutter_selectable_list/modals/dropdown/dropdown.dart';
import 'package:flutter_selectable_list/modals/dropdown/list_select_dropdown.dart';
import 'package:flutter_selectable_list/selectable_list.dart';
import 'package:flutter_selectable_list/modals/side_sheet/list_select_side_sheet.dart';
import 'package:flutter_selectable_list/modals/side_sheet/side_sheet.dart';

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

  final void Function(T)? onConfirmSingle;
  final void Function(List<T>)? onConfirmMulti;

  /// Callback for when scroll extent is reached.
  final Function? onMaxScrollExtent;

  final void Function(List<T>, T, bool)? onMultiSelectionChanged;

  final void Function(String)? onSearchTextChanged;

  final void Function(T?)? onSingleSelectionChanged;

  final FormFieldValidator<List<T>>? multiValidator;
  // final FormFieldSetter<List<T>>? onSavedMulti;
  // final FormFieldSetter<T>? onSavedSingle;

  /// Widget to be displayed when [SelectableListController.loading] is `true`.
  /// The position of this widget can be set using the [SelectableListController.progressIndicatorPosition].
  final Widget? progressIndicator;

  /// Enables the default search functionality. Has no effect when [header] is provided.
  final bool searchable;

  final Widget Function(TextEditingController, Widget)? searchBuilder;

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
    void Function(T)? onConfirm,
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    void Function(T?)? onSelectionChanged,
    this.progressIndicator,
    this.searchable = false,
    this.searchBuilder,
    this.secondary,
    this.shape,
    this.sideSheetProperties = const SideSheetProperties(),
    this.subtitle,
    FormFieldValidator<T>? validator,
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
    void Function(List<T>)? onConfirm,
    this.onMaxScrollExtent,
    this.onSearchTextChanged,
    void Function(List<T>, T, bool)? onSelectionChanged,
    this.progressIndicator,
    this.searchable = false,
    this.searchBuilder,
    this.secondary,
    this.shape,
    this.sideSheetProperties = const SideSheetProperties(),
    this.subtitle,
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

  void _openBottomSheet() {
    // could duplicate the variable
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
              ? ListSelectBottomSheet.multi(
                  // backgroundColor: widget.backgroundColor,
                  controller: _controller as MultiSelectController<T>,
                  // elevation: widget.elevation,
                  initialChildSize:
                      widget.bottomSheetProperties.initialChildSize,
                  itemTitle: widget.itemTitle,
                  maxChildSize: widget.bottomSheetProperties.maxChildSize,
                  minChildSize: widget.bottomSheetProperties.minChildSize,
                  // shape: widget.shape,
                )
              : ListSelectBottomSheet.single(
                  // backgroundColor: widget.backgroundColor,
                  controller: _controller as SingleSelectController<T>,
                  // elevation: widget.elevation,
                  itemTitle: widget.itemTitle,
                );
        }).then(
      (value) {
        if (value == null) {
          if (_controller is MultiSelectController) {
            (_controller as MultiSelectController<T>).value = originalValue;
          } else {
            (_controller as SingleSelectController<T>).value =
                originalValue.isNotEmpty ? originalValue.first : null;
          }
        }
      },
    );
  }

  void _openDialog() {
    // could duplicate the variable
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
            ? ListSelectDialog<T>.multi(
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
                progressIndicator: widget.progressIndicator,
                searchBuilder: widget.searchBuilder,
                searchable: widget.searchable,
                secondary: widget.secondary,
                shape: widget.shape,
                subtitle: widget.subtitle,
              )
            : ListSelectDialog<T>.single(
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
                progressIndicator: widget.progressIndicator,
                searchBuilder: widget.searchBuilder,
                searchable: widget.searchable,
                secondary: widget.secondary,
                shape: widget.shape,
                subtitle: widget.subtitle,
              );
      },
    ).then((result) {
      // If the barrier is dismissed, the controller.value needs
      // to be set back to the original.
      if (result == null) {
        if (_controller is MultiSelectController) {
          (_controller as MultiSelectController<T>).value = originalValue;
        } else {
          (_controller as SingleSelectController<T>).value =
              originalValue.isNotEmpty ? originalValue.first : null;
        }
      }
    });
  }

  void _openDropdown() {
    // could duplicate the variable
    List<T> originalValue = widget.multiselect
        ? [..._controller.value]
        : _controller.value != null
            ? [_controller.value]
            : [];

    showModalDropdown(
      alignment: widget.dropdownProperties.alignment,
      anchorKey: widget.dropdownProperties.anchor ? _anchorKey : null,
      barrierColor: widget.barrierColor,
      barrierDismissible: widget.barrierDismissable,
      barrierLabel: widget.barrierLabel,
      context: context,
      constraints: widget.dropdownProperties.constraints,
      offset: widget.dropdownProperties.offset,
      // transitionDuration: ,
      width: widget.dropdownProperties.width,
      builder: (ctx) {
        return widget.multiselect
            ? ListSelectDropdown.multi(
                controller: _controller as MultiSelectController<T>,
                itemTitle: widget.itemTitle,
              )
            : ListSelectDropdown.single(
                controller: _controller as SingleSelectController<T>,
                itemTitle: widget.itemTitle,
              );
      },
    ).then(
      (value) {
        if (value == null) {
          if (_controller is MultiSelectController) {
            (_controller as MultiSelectController<T>).value = originalValue;
          } else {
            (_controller as SingleSelectController<T>).value =
                originalValue.isNotEmpty ? originalValue.first : null;
          }
        }
      },
    );
  }

  void _openSideSheet() {
    // could duplicate the variable
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
              ? ListSelectSideSheet.multi(
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
                  progressIndicator: widget.progressIndicator,
                  searchable: widget.searchable,
                  searchBuilder: widget.searchBuilder,
                  secondary: widget.secondary,
                  subtitle: widget.subtitle,
                  shape: widget.shape,
                )
              : ListSelectSideSheet.single(
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
                  progressIndicator: widget.progressIndicator,
                  searchable: widget.searchable,
                  searchBuilder: widget.searchBuilder,
                  secondary: widget.secondary,
                  subtitle: widget.subtitle,
                  shape: widget.shape,
                );
        }).then(
      (value) {
        if (value == null) {
          if (_controller is MultiSelectController) {
            (_controller as MultiSelectController<T>).value = originalValue;
          } else {
            (_controller as SingleSelectController<T>).value =
                originalValue.isNotEmpty ? originalValue.first : null;
          }
        }
      },
    );
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
///
/// Type parameter `T` represents the type of the *items*, and type
/// parameter `V` represents the type of the *value* which is `List<T>` for
/// `MultiSelectController` and `T?` for `SingleSelectController`.
abstract class SelectableListController<T> extends ChangeNotifier {
  _SelectableListAnchorState? _anchor;
  List<T> _items;
  List<T>? _filteredItems;
  bool _loading = false;
  bool _searchActive = false;
  ProgressIndicatorPosition progressIndicatorPosition =
      ProgressIndicatorPosition.center;

  /// Gets passed to the default search TextField, and to the `searchBuilder`
  /// callback of SelectableList.
  final TextEditingController _searchController;

  SelectableListController({
    List<T>? items,
    TextEditingController? searchController,
  })  : _items = items ?? [],
        _searchController = searchController ?? TextEditingController();

  List<T> get items => [..._items];
  TextEditingController get searchController => _searchController;
  List<T>? get filteredItems =>
      _filteredItems != null ? [..._filteredItems!] : null;
  bool get loading => _loading;
  bool get searchActive => _searchActive;

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
  // V get value;
  // set value(V newValue);
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
  final double? width;

  /// Applied to the starting position of the dropdown.
  final Offset? offset;
  final BoxConstraints? constraints;

  const DropdownProperties({
    this.alignment = DropdownAligmnent.center,
    this.anchor = true,
    this.width,
    this.offset,
    this.constraints,
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
