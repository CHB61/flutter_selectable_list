import 'package:example/util/example_header.dart';
import 'package:example/util/search_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class CustomSearchDialogExample extends StatefulWidget {
  const CustomSearchDialogExample({super.key});

  @override
  State<CustomSearchDialogExample> createState() =>
      _CustomSearchDialogExampleState();
}

class _CustomSearchDialogExampleState extends State<CustomSearchDialogExample>
    with SearchMixin<CustomSearchDialogExample> {
  Widget _searchBuilder(
    TextEditingController searchController,
    Widget listView,
  ) {
    return searchController.text.isEmpty
        ? historyBuilder()
        : searchBuilder(listView);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Align(
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 800,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ExampleHeader(
                controller: controller,
                onTextChanged: (val) => debounceSearch(val),
              ),
              Expanded(
                child: SelectableList.single(
                  controller: controller,
                  itemTitle: (e) => e.name,
                  searchViewBuilder: _searchBuilder,
                  tileColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
