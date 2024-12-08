import 'package:example/util/data_service.dart';
import 'package:example/util/example_actions.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class SideSheetExample extends StatefulWidget {
  const SideSheetExample({super.key});

  @override
  State<SideSheetExample> createState() => _SideSheetExampleState();
}

class _SideSheetExampleState extends State<SideSheetExample> {
  final DataService _dataService = DataService();
  late final List<Company> _companies;
  final MultiSelectController<Company> _controller = MultiSelectController();

  @override
  void initState() {
    super.initState();
    _companies = _dataService.getData();
    _controller.setItems(_companies);
  }

  void _showSideSheet() {
    showModalSideSheet(
      direction: TextDirection.ltr,
      context: context,
      barrierColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(8),
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(28.0)),
          ),
          child: Column(
            children: [
              Expanded(
                child: SelectableList.multi(
                  controller: _controller,
                  itemTitle: (e) => e.name,
                  pinSelectedValue: true,
                  floatSelectedValue: true,
                  itemExtent: 48,
                ),
              ),
              ExampleActions(controller: _controller),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: _showSideSheet,
        child: const Text('Open Side Sheet'),
      ),
    );
  }
}
