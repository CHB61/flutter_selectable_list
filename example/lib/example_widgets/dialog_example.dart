import 'package:example/util/data_service.dart';
import 'package:example/util/example_actions.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class DialogExample extends StatefulWidget {
  const DialogExample({Key? key}) : super(key: key);

  @override
  State<DialogExample> createState() => _DialogExampleState();
}

class _DialogExampleState extends State<DialogExample> {
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
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        children: [
                          Expanded(
                            child: SelectableList.multi(
                              controller: _controller,
                              elevation: 6,
                              itemTitle: (e) => e.name,
                              itemExtent: 48,
                              floatSelectedValue: true,
                              pinSelectedValue: true,
                            ),
                          ),
                          ExampleActions(controller: _controller),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('Open Dialog'),
        ),
      ),
    );
  }
}
