import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class ExampleHeader extends StatelessWidget {
  final SelectableListController controller;
  final Function(String) onTextChanged;

  const ExampleHeader({
    super.key,
    required this.controller,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Theme(
              data: ThemeData(
                searchBarTheme: SearchBarThemeData(
                  overlayColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  elevation: const WidgetStatePropertyAll(0),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              child: SearchBar(
                controller: controller.searchController,
                onTap: () {
                  controller.setSearchActive(true);
                },
                onChanged: onTextChanged,
                padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 16)),
                leading: IconButton(
                  onPressed: () {
                    controller.setSearchValue("");
                    controller.setFilteredItems(null, notify: false);
                    controller.setSearchActive(!controller.searchActive);
                  },
                  icon: controller.searchActive
                      ? const Icon(Icons.arrow_back)
                      : const Icon(Icons.search),
                ),
                trailing: [
                  if (controller.searchActive)
                    IconButton(
                      onPressed: () {
                        controller.setSearchValue("");
                        controller.setFilteredItems(null);
                      },
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
            ),
          );
        });
  }
}
