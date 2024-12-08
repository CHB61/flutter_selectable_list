import 'package:example/util/data_service.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class BasicSearchExample extends StatefulWidget {
  const BasicSearchExample({super.key});

  @override
  State<BasicSearchExample> createState() => _BasicSearchExampleState();
}

class _BasicSearchExampleState extends State<BasicSearchExample> {
  final DataService _dataService = DataService();
  late final List<Company> _companies;
  final SingleSelectController<Company> _controller = SingleSelectController();

  @override
  void initState() {
    super.initState();

    _companies = _dataService.getData();
    _controller.setItems(_companies);
  }

  @override
  Widget build(BuildContext context) {
    return SelectableListAnchor.single(
      controller: _controller,
      itemTitle: (e) => e.name,
      enableDefaultSearch: true,
      builder: (controller, formFieldState) {
        return TextButton(
          onPressed: () {
            controller.openDialog();
          },
          child: const Text("Open Basic Search Dialog"),
        );
      },
    );
  }
}
