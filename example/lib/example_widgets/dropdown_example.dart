import 'package:example/util/data_service.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class DropdownExample extends StatefulWidget {
  const DropdownExample({super.key});

  @override
  State<DropdownExample> createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  final DataService _dataService = DataService();
  late final List<Company> _companies;
  final MultiSelectController<Company> _controller = MultiSelectController();

  // Key for the widget that opens the dropdown. Passed to the `anchorKey`
  // parameter of `showDropdown` in order to display the dropdown below the anchor.
  // If `anchorKey` is not provided, the dropdown will open with a top Offset of zero.
  final GlobalKey _anchorKey = GlobalKey();

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
        width: 300,
        key: _anchorKey,
        child: TextButton(
          onPressed: () {
            showModalDropdown(
              context: context,
              anchorKey: _anchorKey,
              // elevation: 6,
              barrierColor: Colors.transparent,
              alignment: DropdownAligmnent.center,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              builder: (context) {
                return SelectableList.multi(
                  elevation: 6,
                  floatSelectedValue: true,
                  // itemExtent: 48,
                  controller: _controller,
                  itemTitle: (e) => e.name,
                  // actions: _buildActions(),
                );
              },
            );
          },
          child: const Text('Open Dropdown'),
        ),
      ),
    );
  }
}
