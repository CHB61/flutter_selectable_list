import 'package:example/util/data_service.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class InfiniteScrollExample extends StatefulWidget {
  const InfiniteScrollExample({super.key});

  @override
  State<InfiniteScrollExample> createState() => _InfiniteScrollExampleState();
}

class _InfiniteScrollExampleState extends State<InfiniteScrollExample> {
  final DataService _dataService = DataService();
  List<Company> _companies = [];
  final MultiSelectController<Company> _controller = MultiSelectController();

  @override
  void initState() {
    super.initState();
    _getInitialData();
  }

  // Simulates an API call to get the initial data that will be displayed in
  // the SelectableList.
  Future<void> _getInitialData() async {
    // Set the loading variable to display the ProgressIndicator.
    _controller.setLoading(true);
    _companies = await _dataService.getDataAsync();
    _controller.setLoading(false);

    // Set the items which will rebuild the SelectableList.
    _controller.setItems(_companies);

    // Set the progressIndicatorPosition to 'listItem' now that the initial
    // list has been fetched.
    _controller.progressIndicatorPosition = ProgressIndicatorPosition.listItem;
  }

  // Simulate an API call to get more data.
  Future<void> _getMoreData(SelectableListController controller) async {
    controller.setLoading(true);
    List<Company> moreCompanies = await _dataService.getDataAsync(
      delay: 1000,
      limit: 25,
      offset: _companies.length,
    );
    _companies.addAll(moreCompanies);
    controller.setLoading(false);
    controller.setItems(_companies);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        height: 500,
        width: 800,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
        ),
        child: SelectableList.multi(
          controller: _controller,
          // itemTitle: (e) => Text(e.name),
          itemTitle: (e) => e.name,
          subtitle: (e) => const Text(
            "Supporting text long enough to be displayed on two lines. Supporting text long enough to be displayed on two lines.",
          ),
          secondary: (e) => const Icon(Icons.person),
          isThreeLine: true,
          scrollThreshold: 0.9,
          onScrollThresholdReached: _getMoreData,
          floatSelectedValue: true,
          pinSelectedValue: true,
        ),
      ),
    );
  }
}
