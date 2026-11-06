import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

// class lưu trữ và lấy dữ liệu ở shared_preferences
class TodoRepository {
  // constructor có tham số đặt tên tuỳ chọn dùng để khởi tạo _preferences
  TodoRepository({SharedPreferencesAsync? preferences}) // tham số có thể null
    : _preferences = preferences ?? SharedPreferencesAsync();
  // : Là giá trị khởi tạo ban đầu cho trường _preferences trước khi thâm constructor chạy
  // Nếu được truyền tham số preferences thì dùng giá trị đó , nếu chưa truyền thì tạo mới 1 SharedPreferencesAsync();
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

/**
 Cách viết constructor kiểu thông thường là initializing formal parameter : 
 TodoRepository(this._preferences);
 Tham số _preferences được gán thẳng vào field cũng tên.
 Nhưng trong trường hợp cần giá trị mặc định khi tham số bị bỏ qua hoặc là null thì cần sử dụng kiểu initializer list
 */
