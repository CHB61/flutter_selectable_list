import 'package:example/util/search_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class AsyncSearchExample extends StatefulWidget {
  const AsyncSearchExample({super.key});

  @override
  State<AsyncSearchExample> createState() => _AsyncSearchExampleState();
}

class _AsyncSearchExampleState extends State<AsyncSearchExample>
    with SearchMixin<AsyncSearchExample> {
  @override
  Widget build(BuildContext context) {
    return SelectableListAnchor.single(
      controller: controller,
      itemTitle: (e) => e.name,
      enableDefaultSearch: true,
      onSearchTextChanged: (val) => debounceSearch(val),
      onScrollThresholdReached: getMoreData,
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
