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
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();
  final DataService _dataService = DataService();
  late final List<Company> _companies;
  // final MultiSelectController<Company> _controller = MultiSelectController();

  @override
  void initState() {
    super.initState();

    _companies = _dataService.getData();
    // _controller.setItems(_companies);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: SelectableListAnchor.multi(
          barrierColor: Colors.transparent,
          itemExtent: 48,
          floatSelectedValue: true,
          elevation: 6,
          enableDefaultSearch: true,
          formFieldKey: _formFieldKey,
          itemTitle: (e) => e.name,
          items: _companies,
          onConfirm: (val) {
            _formFieldKey.currentState?.validate();
          },
          autovalidateMode: AutovalidateMode.always,
          // validator: (value) {
          //   if (value?.isEmpty ?? true) return 'Required';
          //   return null;
          // },
          builder: (controller, state) {
            return TextButton(
              onPressed: () async {
                controller.openDropdown();
                await Future.delayed(const Duration(milliseconds: 500));
                controller.openSideSheet();
                await Future.delayed(const Duration(milliseconds: 500));
                controller.openDialog();
                await Future.delayed(const Duration(milliseconds: 500));
                controller.openBottomSheet();
              },
              child: const Text('Open view'),
            );
            // return Column(
            //   mainAxisSize: MainAxisSize.min,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     TextButton(
            //       onPressed: () {
            //         controller.openView();
            //       },
            //       child: Container(
            //         alignment: Alignment.center,
            //         width: 200,
            //         child: const Text('Open view'),
            //       ),
            //     ),
            //     state.hasError
            //         ? Text(
            //             state.errorText ?? "",
            //             style: const TextStyle(color: Colors.red, fontSize: 12),
            //           )
            //         : Container(),
            //   ],
            // );
          },
        ),
      ),
    );
  }
}
