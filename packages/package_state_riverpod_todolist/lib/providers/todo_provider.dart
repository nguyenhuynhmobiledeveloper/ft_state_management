import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';
import '../repositories/todo_repository.dart';
import 'todo_state.dart';

final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(),
);

final todoProvider = NotifierProvider<TodoNotifier, TodoState>(
  TodoNotifier.new,
);

/// Holds the same state as the BLoC example and serializes all operations.
class TodoNotifier extends Notifier<TodoState> {
  Future<void> _pending = Future<void>.value();

  @override
  TodoState build() => const TodoState();

  Future<void> _enqueue(Future<void> Function() operation) {
    final result = _pending.then((_) async {
      if (ref.mounted) await operation();
    });
    // Each operation handles its own storage error; keep the queue usable.
    _pending = result;
    return result;
  }

  Future<void> loadTodos() => _enqueue(() async {
    state = state.copyWith(isLoading: true);
    try {
      final todos = await ref.read(todoRepositoryProvider).loadTodos();
      if (!ref.mounted) return;
      state = state.copyWith(todos: todos, isLoading: false);
    } catch (_) {
      if (!ref.mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tải danh sách công việc.',
      );
    }
  });

  Future<void> changeFilter(TodoFilter filter) => _enqueue(() async {
    state = state.copyWith(filter: filter);
  });

  Future<void> addTodo(String title) => _enqueue(() async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return;

    await _saveTodos([
      ...state.todos,
      Todo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: trimmedTitle,
      ),
    ]);
  });

  Future<void> toggleTodo(String id) => _enqueue(() async {
    await _saveTodos(
      state.todos.map((todo) {
        if (todo.id != id) return todo;
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }).toList(),
    );
  });

  Future<void> deleteTodo(String id) => _enqueue(() async {
    await _saveTodos(state.todos.where((todo) => todo.id != id).toList());
  });

  Future<void> _saveTodos(List<Todo> todos) async {
    try {
      await ref.read(todoRepositoryProvider).saveTodos(todos);
      if (!ref.mounted) return;
      state = state.copyWith(todos: todos);
    } catch (_) {
      if (!ref.mounted) return;
      state = state.copyWith(errorMessage: 'Không thể lưu thay đổi.');
    }
  }
}
