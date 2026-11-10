import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/todo_provider.dart';
import 'repositories/todo_repository.dart';
import 'screens/todo_screen.dart';

/// Khởi tạo Flutter và chạy ứng dụng To-Do List dùng package `provider`.
void runPackageStateProviderTodolistApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TodoApp(repository: TodoRepository()));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key, required this.repository});

  final TodoRepository repository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repository đã được tạo bên ngoài: .value chuyển đúng instance đó xuống cây widget,
        // cũng giúp test thay bằng repository giả.
        Provider<TodoRepository>.value(value: repository),

        // ChangeNotifierProvider : Đưa state vào widget tree -> tạo và tự dispose TodoProvider.
        // Controller lấy repository từ Provider ngay phía trên.
        ChangeNotifierProvider<TodoProvider>(
          create: (context) =>
              TodoProvider(repository: context.read<TodoRepository>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo Provider',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: const TodoScreen(),
      ),
    );
  }
}
