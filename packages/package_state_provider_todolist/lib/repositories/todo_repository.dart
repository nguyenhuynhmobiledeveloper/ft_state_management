import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

/// Lớp lưu trữ độc lập với Provider; dùng chung định dạng với hai bản còn lại.
class TodoRepository {
  /// Có thể truyền SharedPreferencesAsync riêng để kiểm thử.
  TodoRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _storageKey = 'todos';
  final SharedPreferencesAsync _preferences;

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

  /// Mỗi lần thay đổi ghi lại cả mảng, đúng thứ tự và đúng khóa của bản BLoC.
  Future<void> saveTodos(List<Todo> todos) async {
    final jsonString = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await _preferences.setString(_storageKey, jsonString);
  }
}
