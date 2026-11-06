import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';
import 'repositories/todo_repository.dart';
import 'screens/todo_screen.dart';

/// Initializes Flutter and launches the Todo list example.
void runPackageStateBlocTodolistApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    TodoApp(repository: TodoRepository()),
  ); // TodoRepository đang không được truyền tham số SharedPreference nên bên trong nó sẽ tự tạo 1 cái mới
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key, required this.repository});

  final TodoRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo BLoC',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      // Cung cấp bloc cho widget sử dụng
      home: BlocProvider(
        create: (_) =>
            TodoBloc(repository: repository)..add(const TodosRequested()),
        // thêm luôn event lấy danh sách todo
        child: const TodoScreen(),
      ),
    );
  }
}
