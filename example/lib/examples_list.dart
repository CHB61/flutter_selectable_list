import 'package:example/example_widgets/anchor_example.dart';
import 'package:example/example_widgets/bottom_sheet_example.dart';
import 'package:example/example_widgets/dialog_example.dart';
import 'package:example/example_widgets/dropdown_example.dart';
import 'package:example/example_widgets/infinite_scroll_example.dart';
import 'package:example/example_widgets/search/async_search_example.dart';
import 'package:example/example_widgets/search/basic_search_example.dart';
import 'package:example/example_widgets/search/custom_search_header_example.dart';
import 'package:example/example_widgets/search/search_view_example.dart';
import 'package:example/example_widgets/side_sheet_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class ExamplesList extends StatefulWidget {
  final void Function(Example example) onExampleSelected;
  final Example? selectedExample;

  const ExamplesList({
    super.key,
    required this.onExampleSelected,
    required this.selectedExample,
  });

  @override
  State<ExamplesList> createState() => _ExamplesListState();
}

class _ExamplesListState extends State<ExamplesList> {
  final List<ExampleItem> _items = [
    ExampleItem(
      example: Example(
        name: 'Anchor',
        widget: const AnchorExample(),
      ),
    ),
    // ExampleItem(
    //   example: Example(
    //     name: 'Bottom Sheet',
    //     widget: const BottomSheetExample(),
    //   ),
    // ),
    // ExampleItem(
    //   example: Example(
    //     name: 'Dialog',
    //     widget: const DialogExample(),
    //   ),
    // ),
    // ExampleItem(
    //   example: Example(
    //     name: 'Dropdown',
    //     widget: const DropdownExample(),
    //   ),
    // ),
    ExampleItem(
      example: Example(
        name: 'Infinite Scroll',
        widget: const InfiniteScrollExample(),
      ),
    ),
    ExampleItem(
      group: ExampleGroup(
        name: 'Modals Without Anchor',
        examples: [
          Example(name: 'Bottom Sheet', widget: const BottomSheetExample()),
          Example(name: 'Dialog', widget: const DialogExample()),
          Example(name: 'Dropdown', widget: const DropdownExample()),
          Example(name: 'Side Sheet', widget: const SideSheetExample()),
        ],
      ),
    ),
    ExampleItem(
      group: ExampleGroup(
        name: 'Search',
        examples: [
          Example(name: 'Basic Search', widget: const BasicSearchExample()),
          Example(name: 'Async Search', widget: const AsyncSearchExample()),
          Example(name: 'Search View', widget: const SearchViewExample()),
          Example(
              name: 'Custom Search Header',
              widget: const CustomSearchDialogExample()),
        ],
      ),
    ),
  ];

  Widget _buildGroup(ExampleGroup group) {
    return ExpansionTile(
      title: Text(group.name),
      children: group.examples.map((e) => _buildExample(e)).toList(),
    );
  }

  Widget _buildExample(Example example) {
    return CheckboxListTile(
      value: example == widget.selectedExample,
      onChanged: (val) => widget.onExampleSelected(example),
      title: Text(example.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SelectableList.single(
      items: _items,
      itemBuilder: (item, index) {
        if (item.group != null) {
          return _buildGroup(item.group!);
        }
        return _buildExample(item.example!);
      },
    );
  }
}

class ExampleGroup {
  String name;
  List<Example> examples;

  ExampleGroup({
    required this.name,
    required this.examples,
  });
}

class Example {
  String name;
  Widget widget;

  Example({
    required this.name,
    required this.widget,
  });
}

class ExampleItem {
  ExampleGroup? group;
  Example? example;

  ExampleItem({
    this.example,
    this.group,
  });
}
