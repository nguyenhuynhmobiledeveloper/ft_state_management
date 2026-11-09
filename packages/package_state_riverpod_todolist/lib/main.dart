import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/todo_provider.dart';
import 'repositories/todo_repository.dart';
import 'screens/todo_screen.dart';

/// Initializes Flutter and launches the Riverpod Todo list example.
/// Hàm khởi động: chuẩn bị Flutter và chạy TodoApp với kho dữ liệu TodoRepository.
void runPackageStateRiverpodTodolistApp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    TodoApp(repository: TodoRepository()),
  ); // Khai báo tạo 1 widget app chính
}

// class widget app chính
class TodoApp extends StatelessWidget {
  /// TodoApp là widget gốc, dùng ProviderScope để cấp các provider cho toàn ứng dụng.
  /// Nhận repository để ứng dụng có thể truyền nó vào Riverpod qua override.
  const TodoApp({super.key, required this.repository});

  final TodoRepository repository;
  // ProviderScope : Điểm bắt đầu của RiverPod : cần bọc app bằng ProviderScope - Giống như 1 container quản lý các Provider
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      // build tạo cây widget; overrideWithValue khiến todoRepositoryProvider dùng repository này.
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
