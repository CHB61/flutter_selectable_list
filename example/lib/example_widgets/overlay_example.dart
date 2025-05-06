import 'package:example/util/example_anchor_field.dart';
import 'package:example/util/data_service.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class OverlayExample extends StatefulWidget {
  const OverlayExample({super.key});

  @override
  State<OverlayExample> createState() => _OverlayExampleState();
}

class _OverlayExampleState extends State<OverlayExample> {
  final MultiSelectController<Company> _controller = MultiSelectController();
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    List<Company> companies = _dataService.getData(limit: 8);
    _controller.setItems(companies);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          const Placeholder(fallbackHeight: 1000),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Placeholder(fallbackWidth: 1500),
                SizedBox(
                  width: 400,
                  child: SelectableListAnchor.multi(
                    backgroundColor: Colors.green.shade200,
                    // elevation: 0,
                    controller: _controller,
                    // barrierColor: Colors.transparent,
                    enableDefaultSearch: true,
                    formFieldKey: _formFieldKey,
                    itemTitle: (e) => e.name,
                    pinSelectedValue: true,
                    onSelectionChanged: (value, item, checked) {
                      _formFieldKey.currentState?.validate();
                      _textController.text = item.name;
                    },
                    shrinkWrap: true,
                    // itemExtent: 48,
                    builder: (controller, state) {
                      return ExampleAnchorField(
                        controller: controller,
                        textController: _textController,
                        onPressed: () => controller.openOverlay(
                            // minHeight: 250,
                            // keepInBounds: true,
                            // avoidOverlap: true,
                            // flexiblePosition: true,
                            ),
                        label: "Open Overlay",
                        state: state,
                      );
                    },
                  ),
                ),
                const Placeholder(fallbackWidth: 1500),
              ],
            ),
          ),
          const Placeholder(fallbackHeight: 1000),
        ],
      ),
    );
  }
}
