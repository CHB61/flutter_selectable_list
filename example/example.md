```dart
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

  @override
  Widget build(BuildContext context) {
    return SelectableListAnchor.multi(
      items: _companies,
      itemTitle: (e) => e.name,
      elevation: 6,
      enableDefaultSearch: true,
      formFieldKey: _formFieldKey,
      pinSelectedValue: true,
      onConfirm: (val) {
        _formFieldKey.currentState?.validate();
      },
      validator: (value) {
      if (value?.isEmpty ?? true) return 'Required';
        return null;
      },
      builder: (controller, state) {
        return TextButton(
          onPressed: () async {
            controller.openDialog();
          },
          child: const Text('Open view'),
        );
      },
    );
  }

```
