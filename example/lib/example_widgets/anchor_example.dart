import 'package:example/util/example_anchor_field.dart';
import 'package:example/util/data_service.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class AnchorExample extends StatefulWidget {
  const AnchorExample({super.key});

  @override
  State<AnchorExample> createState() => _AnchorExampleState();
}

class _AnchorExampleState extends State<AnchorExample> {
  final SingleSelectController<Company> _controller = SingleSelectController();
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    _controller.setLoading(true);
    List<Company> companies =
        await _dataService.getDataAsync(delay: 500, limit: 25);
    _controller.setLoading(false);
    _controller.setItems(companies);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 400,
        child: SelectableListAnchor.single(
          controller: _controller,
          enableDefaultSearch: true,
          formFieldKey: _formFieldKey,
          itemTitle: (e) => e.name,
          pinSelectedValue: true,
          onSelectionChanged: (value) {
            _formFieldKey.currentState?.validate();
            _textController.text = value?.name ?? "";
            _controller.removeOverlay();
          },
          validator: (value) {
            if (value == null) return 'Required';
            return null;
          },
          builder: (controller, state) {
            return ExampleAnchorField(
              controller: controller,
              textController: _textController,
              onPressed: () => controller.openOverlay(),
              label: "Open View",
              state: state,
            );
          },
        ),
      ),
    );
  }
}
