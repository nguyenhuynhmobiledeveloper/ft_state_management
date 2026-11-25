import 'package:flutter/material.dart';

import 'screens/todo_screen.dart';

void main() => runPackageStateValueNotifierTodolistApp();

void runPackageStateValueNotifierTodolistApp() {
  runApp(const ValueNotifierTodoApp());
}

class ValueNotifierTodoApp extends StatelessWidget {
  const ValueNotifierTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do với ValueNotifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const TodoScreen(),
    );
  }
}
