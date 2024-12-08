```dart
import 'package:flutter/material.dart';
import 'package:flutter_selectable_list/flutter_selectable_list.dart';

  @override
  Widget build(BuildContext context) {
    return SelectableListAnchor.multi(
      barrierColor: Colors.transparent,
      pinSelectedValue: true,
      elevation: 6,
      enableDefaultSearch: true,
      formFieldKey: _formFieldKey,
      itemTitle: (e) => e.name,
      items: _companies,
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
