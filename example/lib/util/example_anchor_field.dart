import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

class ExampleAnchorField extends StatelessWidget {
  final SelectableListController controller;
  final String label;
  final VoidCallback onPressed;
  final FormFieldState? state;
  final TextEditingController textController;

  const ExampleAnchorField({
    super.key,
    required this.controller,
    required this.label,
    required this.onPressed,
    this.state,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextField(
        canRequestFocus: false,
        controller: textController,
        mouseCursor: SystemMouseCursors.click,
        onTap: onPressed,
        decoration: InputDecoration(
          hintText: label,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: state?.hasError ?? false
                  ? Theme.of(context).colorScheme.error
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
