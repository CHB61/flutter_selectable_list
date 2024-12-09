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
    List<Company> companies = await _dataService.getDataAsync(delay: 1000);
    _controller.setLoading(false);
    _controller.setItems(companies);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: SelectableListAnchor.single(
          controller: _controller,
          barrierColor: Colors.transparent,
          enableDefaultSearch: true,
          formFieldKey: _formFieldKey,
          itemTitle: (e) => e.name,
          pinSelectedValue: true,
          onSelectionChanged: (item) {
            _formFieldKey.currentState?.validate();
            _textController.text = item?.name ?? "";
            Navigator.of(context).pop(item);
          },
          validator: (value) {
            if (value == null) return 'Required';
            return null;
          },
          builder: (controller, state) {
            return ExampleAnchorField(
              controller: controller,
              textController: _textController,
              onPressed: () => controller.openDropdown(),
              label: "Open View (Dropdown)",
              state: state,
            );
          },
        ),
      ),
    );
  }
}

class ExampleAnchorField extends StatelessWidget {
  final SelectableListController controller;
  final String label;
  final VoidCallback onPressed;
  final FormFieldState state;
  final TextEditingController textController;

  const ExampleAnchorField({
    super.key,
    required this.controller,
    required this.label,
    required this.onPressed,
    required this.state,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextFormField(
        canRequestFocus: false,
        controller: textController,
        mouseCursor: SystemMouseCursors.click,
        onTap: onPressed,
        decoration: InputDecoration(
          hintText: label,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: state.hasError
                  ? Theme.of(context).colorScheme.error
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
