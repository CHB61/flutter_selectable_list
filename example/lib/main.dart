import 'package:example/example_view.dart';
import 'package:example/examples_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Company {
  int id;
  String name;

  Company({
    required this.id,
    required this.name,
  });
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // useMaterial3: false,
          // colorScheme: const ColorScheme.dark(),
          // dialogTheme: DialogTheme(),
          // dividerTheme: const DividerThemeData(
          //   color: Colors.blue,
          // ),
          ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Example? _selectedExample;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Selectable List Demo'),
        scrolledUnderElevation: 0,
      ),
      body: Row(
        children: [
          SizedBox(
            width: 350,
            child: ExamplesList(
              selectedExample: _selectedExample,
              onExampleSelected: (example) {
                setState(() {
                  _selectedExample = example;
                });
              },
            ),
          ),
          const VerticalDivider(
            width: 1,
          ),
          Expanded(
            child: ExampleView(example: _selectedExample),
          ),
        ],
      ),
    );
  }
}
