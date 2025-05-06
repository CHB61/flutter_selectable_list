import 'package:example/util/data_service.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class BottomSheetExample extends StatefulWidget {
  const BottomSheetExample({super.key});

  @override
  State<BottomSheetExample> createState() => _BottomSheetExampleState();
}

class _BottomSheetExampleState extends State<BottomSheetExample> {
  final DataService _dataService = DataService();
  late final List<Company> _companies;
  final MultiSelectController<Company> _controller = MultiSelectController();

  @override
  void initState() {
    super.initState();

    _companies = _dataService.getData();
    _controller.setItems(_companies);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: TextButton(
          onPressed: () {
            showBottomSheet(
              context: context,
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              constraints: const BoxConstraints(
                maxHeight: 400,
                maxWidth: 800,
              ),
              builder: (context) {
                return SelectableList.multi(
                  controller: _controller,
                  itemTitle: (e) => e.name,
                  floatSelectedValue: true,
                  pinSelectedValue: true,
                  itemExtent: 48,
                );
              },
            );
          },
          child: const Text('Open Bottom Sheet'),
        ),
      ),
    );
  }
}
