import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/todo_provider.dart';
import 'repositories/todo_repository.dart';
import 'screens/todo_screen.dart';

/// Initializes Flutter and launches the Riverpod Todo list example.
void runPackageStateRiverpodTodolistApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TodoApp(repository: TodoRepository()));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key, required this.repository});

  final TodoRepository repository;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [todoRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo RiverPod',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const TodoScreen(),
      ),
    );
  }
}
