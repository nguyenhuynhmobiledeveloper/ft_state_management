import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

// class của kho lưu trữ và lấy dữ liệu bằng shared_preferences
class TodoRepository {
  TodoRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  // Định nghĩa các thuộc tính trong class
  static const _storageKey = 'todos';

  final SharedPreferencesAsync
  _preferences; // Là kho Shared để lưu trữ dữ liệu trong máy

  // Lấy ra tất cả các todo list đang lưu
  Future<List<Todo>> loadTodos() async {
    final raw = await _preferences.getString(_storageKey);
    if (raw == null) return [];

    // Gỉai mã từ Json sang 1 mảng List
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Todo.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Lưu danh sách todo vào shared_preferences
  Future<void> saveTodos(List<Todo> todos) async {
    // Mã hoá từ
    final jsonString = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await _preferences.setString(_storageKey, jsonString);
  }
}
