import 'package:example/util/search_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class SearchViewExample extends StatefulWidget {
  const SearchViewExample({super.key});

  @override
  State<SearchViewExample> createState() => _SearchViewExampleState();
}

class _SearchViewExampleState extends State<SearchViewExample>
    with SearchMixin<SearchViewExample> {
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
    return SelectableListAnchor.single(
      controller: controller,
      enableDefaultSearch: true,
      itemTitle: (e) => e.name,
      onSearchTextChanged: (val) => debounceSearch(val),
      searchViewBuilder: _searchBuilder,
      builder: (controller, formFieldState) {
        return TextButton(
          onPressed: () {
            controller.openDialog();
          },
          child: const Text('Open Dialog'),
        );
      },
    );
  }
}
