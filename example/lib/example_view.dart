import 'package:example/examples_list.dart';
import 'package:flutter/material.dart';

class ExampleView extends StatefulWidget {
  final Example? example;

  const ExampleView({
    super.key,
    required this.example,
  });

  @override
  State<ExampleView> createState() => _ExampleDetailsState();
}

class _ExampleDetailsState extends State<ExampleView> {
  @override
  Widget build(BuildContext context) {
    return widget.example?.widget ??
        const Center(child: Text("Select an Example"));
  }
}
