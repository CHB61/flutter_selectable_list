import 'dart:async';

import 'package:example/util/data_service.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

mixin SearchMixin<T extends StatefulWidget> on State<T> {
  final SingleSelectController<Company> controller = SingleSelectController();
  final DataService dataService = DataService();
  final List<String> searchHistory = ['Company 100', '101', '9'];
  List<Company> suggestedItems = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    suggestedItems = [...dataService.allCompanies]..shuffle();
    getInitialData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // Simulates an API request to get the initial data.
  Future<void> getInitialData() async {
    controller.setLoading(true);
    dataService.loadedData = await dataService.getDataAsync();
    controller.setLoading(false);
    controller.setItems(dataService.loadedData);

    // Set the progressIndicatorPosition to 'listItem' now that the initial
    // list has been fetched.
    controller.progressIndicatorPosition = ProgressIndicatorPosition.listItem;
  }

  List<Company> localSearch(String text) {
    return dataService.loadedData
        .where((e) => e.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  void debounceSearch(
    String text, [
    int debounce = 500,
  ]) async {
    // searchText = text;
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (text.isEmpty) {
      controller.setLoading(false);
      controller.setFilteredItems(null);
    } else {
      _debounce = Timer(
        Duration(milliseconds: debounce),
        () async {
          search(text);
        },
      );
    }
  }

  void search(String text) {
    _search(text).then(
      (result) {
        if (controller.searchController.text == text) {
          _processSearchResult(result, controller);
        }
      },
    );
  }

  Future<List<Company>> _search(String text) async {
    if (!searchHistory.contains(text)) {
      searchHistory.insert(0, text);
    }
    List<Company> filteredCompanies = [];

    // search local data
    filteredCompanies = localSearch(text);
    controller.setFilteredItems(filteredCompanies);

    // async search
    controller.setLoading(true);
    List<Company> result = await dataService.getDataAsync(
      delay: 1500,
      searchText: controller.searchController.text,
    );
    controller.setLoading(false);

    return result;
  }

  void _processSearchResult(
    List<Company> result,
    SelectableListController controller,
  ) {
    if (result.isEmpty) {
      controller.setFilteredItems(List<Company>.empty());
      return;
    }

    List<Company> filteredItems = result;
    suggestedItems.shuffle();
    controller.setFilteredItems(filteredItems);
  }

  // Simulate an API call to get more data.
  Future<void> getMoreData(SelectableListController controller) async {
    controller.setLoading(true);
    int offset;

    if (controller.filteredItems?.isNotEmpty ?? false) {
      offset = controller.filteredItems!.length;
    } else {
      offset = controller.items.length;
    }

    List<Company> moreCompanies = await dataService.getDataAsync(
      delay: 1000,
      limit: 25,
      offset: offset,
      searchText: controller.searchController.text,
    );

    controller.setLoading(false);
    if (controller.filteredItems?.isNotEmpty ?? false) {
      controller
          .setFilteredItems([...controller.filteredItems!, ...moreCompanies]);
    } else {
      dataService.loadedData.addAll(moreCompanies);
      controller.setItems([...controller.items, ...moreCompanies]);
    }
  }

  Widget searchBuilder(Widget listView) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: !controller.loading &&
                  (controller.filteredItems?.isEmpty ?? false)
              ? const Center(child: Text("No results found"))
              : listView,
        ),
        _buildSuggested(controller),
      ],
    );
  }

  Widget historyBuilder([
    bool includeBottom = true,
    Function? onTap,
  ]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: searchHistory
              .take(3)
              .map(
                (e) => ListTile(
                  title: Text(e),
                  leading: const Icon(Icons.history),
                  onTap: () {
                    controller.setSearchValue(e, notify: false);
                    search(e);
                    onTap?.call();
                  },
                ),
              )
              .toList(),
        ),
        if (includeBottom) _buildSuggested(controller),
      ],
    );
  }

  Widget suggestionsBuilder(
    SelectableListController controller, [
    bool includeBottom = true,
    Function? onTap,
  ]) {
    List<Company> data = localSearch(controller.searchController.text);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: data
              .take(3)
              .map(
                (e) => ListTile(
                  leading: const Icon(Icons.search),
                  title: Text(e.name),
                  onTap: () {
                    controller.setSearchValue(e.name, notify: false);
                    search(e.name);
                    onTap?.call();
                  },
                ),
              )
              .toList(),
        ),
        if (includeBottom) _buildSuggested(controller),
      ],
    );
  }

  Widget _buildSuggested(
    SelectableListController controller, [
    int count = 5,
  ]) {
    Iterable<Company> items = suggestedItems.take(count);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text("Suggested"),
        SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: items
                  .map((e) => _suggestedCompany(e.name, controller))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _suggestedCompany(
    String company,
    SelectableListController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            controller.setSearchValue(company, notify: false);
            search(company);
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 100,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const Icon(Icons.business),
                Text(
                  company,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
