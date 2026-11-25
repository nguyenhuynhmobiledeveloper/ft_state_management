import 'package:flutter/material.dart';

import 'screens/examples_screen.dart';

void main() => runPackageStateValueNotifierApp();

void runPackageStateValueNotifierApp() {
  runApp(const ValueNotifierExamplesApp());
}

class ValueNotifierExamplesApp extends StatelessWidget {
  const ValueNotifierExamplesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Học ValueNotifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const ExamplesScreen(),
    );
  }
}
