import 'package:example/util/example_anchor_field.dart';
import 'package:example/main.dart';
import 'package:example/util/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class OverlayAnchorExample extends StatefulWidget {
  const OverlayAnchorExample({super.key});

  @override
  State<OverlayAnchorExample> createState() => _OverlayAnchorExampleState();
}

class _OverlayAnchorExampleState extends State<OverlayAnchorExample> {
  final OverlayAnchorController _overlayController = OverlayAnchorController();
  final MultiSelectController<Company> _controller = MultiSelectController();
  final TextEditingController _textController = TextEditingController();
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
                  child: OverlayAnchor(
                    onTapOutside: (p0) => _overlayController.hideOverlay(),
                    anchorBuilder: () => ExampleAnchorField(
                      controller: _controller,
                      label: 'My Overlay',
                      onPressed: () => _overlayController.showOverlay(),
                      textController: _textController,
                    ),
                    controller: _overlayController,
                    keepInBounds: true,
                    minHeight: 100,
                    height: 300,
                    overlayBuilder: (context) {
                      return Container(
                        color: Colors.blue,
                        child: SelectableList.multi(
                          controller: _controller,
                          tileColor: Colors.green.shade200,
                          itemTitle: (e) => e.name,
                        ),
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
