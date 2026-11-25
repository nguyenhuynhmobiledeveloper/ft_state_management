import 'package:flutter/foundation.dart';

import '../models/todo.dart';
import '../models/todo_state.dart';

/// Cách 2: kế thừa ValueNotifier để tự mang value và API lắng nghe.
/// UI gọi các phương thức nghiệp vụ bên dưới thay vì tự sửa state.
class TodoController extends ValueNotifier<TodoState> {
  TodoController() : super(TodoState());

  int _nextId = 1;

  void addTodo(String title) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return;
    final todo = Todo(id: _nextId++, title: trimmedTitle);
    value = value.copyWith(todos: [...value.todos, todo]);
  }

  void toggleTodo(int id) {
    if (!value.todos.any((todo) => todo.id == id)) return;
    value = value.copyWith(
      todos: [
        for (final todo in value.todos)
          if (todo.id == id)
            todo.copyWith(isCompleted: !todo.isCompleted)
          else
            todo,
      ],
    );
  }

  void removeTodo(int id) {
    if (!value.todos.any((todo) => todo.id == id)) return;
    value = value.copyWith(
      todos: value.todos.where((todo) => todo.id != id).toList(),
    );
  }

  void changeFilter(TodoFilter filter) {
    if (filter == value.filter) return;
    value = value.copyWith(filter: filter);
  }

  void changeQuery(String query) {
    if (query == value.query) return;
    value = value.copyWith(query: query);
  }

  void clearCompleted() {
    if (value.completedCount == 0) return;
    value = value.copyWith(
      todos: value.todos.where((todo) => !todo.isCompleted).toList(),
    );
  }
}
