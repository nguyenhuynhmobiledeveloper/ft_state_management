import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoRepository {
  TodoRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _storageKey = 'todos';
  final SharedPreferencesAsync _preferences;

  Future<List<Todo>> loadTodos() async {
    final raw = await _preferences.getString(_storageKey);
    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Todo.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final jsonString = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await _preferences.setString(_storageKey, jsonString);
  }
}
