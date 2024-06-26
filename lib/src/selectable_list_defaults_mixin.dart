import 'package:flutter/material.dart';
import 'selectable_list_anchor.dart';

mixin ModalDefaultsMixin<T> {
  Widget getDefaultModalHeader({
    required SelectableListController<T> controller,
    String? headerTitle,
    String Function(T)? itemTitle,
    void Function(String)? onSearchTextChanged,
    final EdgeInsetsGeometry? padding,
    bool searchable = false,
  }) {
    return _DefaultHeader<T>(
      controller: controller,
      headerTitle: headerTitle,
      itemTitle: itemTitle,
      onSearchTextChanged: onSearchTextChanged,
      searchable: searchable,
      padding: padding,
    );
  }

  Widget getDefaultModalActions({
    required SelectableListController<T> controller,
    required bool multiselect,
    required List<T> originalValue,
    void Function(List<T>)? onConfirmMulti,
    void Function(T?)? onConfirmSingle,
  }) {
    return _DefaultActions<T>(
      controller: controller,
      multiselect: multiselect,
      originalValue: originalValue,
      onConfirmMulti: onConfirmMulti,
      onConfirmSingle: onConfirmSingle,
    );
  }
}

class _DefaultHeader<T> extends StatefulWidget {
  final SelectableListController<T> controller;
  final String? headerTitle;
  final String Function(T)? itemTitle;
  final void Function(String)? onSearchTextChanged;
  final EdgeInsetsGeometry? padding;
  final bool searchable;

  const _DefaultHeader({
    super.key,
    required this.controller,
    this.headerTitle,
    this.itemTitle,
    this.onSearchTextChanged,
    this.padding,
    this.searchable = false,
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
    return ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          return Padding(
            padding:
                widget.padding ?? const EdgeInsets.only(bottom: 12, right: 20),
            child: widget.controller.searchActive
                ? TextField(
                    controller: widget.controller.searchController,
                    focusNode: _focusNode,
                    onChanged: widget.onSearchTextChanged ?? _search,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: IconButton(
                        onPressed: () {
                          widget.controller.setSearchValue("");
                          widget.controller.setFilteredItems(null, false);
                          widget.controller.setSearchActive(false);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          widget.controller.setSearchValue("");
                          widget.controller.setFilteredItems(null);
                        },
                        icon: const Icon(Icons.close),
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
                            widget.headerTitle ?? "Select",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        widget.searchable
                            ? IconButton(
                                onPressed: () {
                                  widget.controller.setSearchActive(true);
                                  _focusNode.requestFocus();
                                },
                                icon: const Icon(Icons.search),
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
  final void Function(List<T>)? onConfirmMulti;
  final void Function(T?)? onConfirmSingle;
  final bool multiselect;

  const _DefaultActions({
    super.key,
    required this.controller,
    required this.multiselect,
    required this.originalValue,
    required this.onConfirmMulti,
    required this.onConfirmSingle,
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
              if (!multiselect && controller.value == null) {
                Navigator.pop(context, []);
              } else {
                Navigator.pop(context, controller.value);
              }
              multiselect
                  ? onConfirmMulti?.call(controller.value)
                  : onConfirmSingle?.call(controller.value);
            },
            child: const Text('OK'),
            // child: confirmText ?? const Text("OK"),
          )
        ],
      ),
    );
  }
}
