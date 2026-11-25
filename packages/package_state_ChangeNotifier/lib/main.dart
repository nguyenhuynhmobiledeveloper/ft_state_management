import 'package:flutter/material.dart';

import 'screens/examples_screen.dart';

void main() => runPackageStateChangeNotifierApp();

void runPackageStateChangeNotifierApp() {
  runApp(const ChangeNotifierExamplesApp());
}

class ChangeNotifierExamplesApp extends StatelessWidget {
  const ChangeNotifierExamplesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Học ChangeNotifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const ExamplesScreen(),
    );
  }
}
