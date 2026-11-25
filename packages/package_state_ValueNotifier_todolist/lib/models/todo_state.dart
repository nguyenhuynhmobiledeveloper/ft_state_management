import 'todo.dart';

enum TodoFilter { all, active, completed }

/// Gom các giá trị liên quan vào một snapshot để cập nhật nhất quán.
class TodoState {
  TodoState({
    List<Todo> todos = const [],
    this.filter = TodoFilter.all,
    this.query = '',
  }) : todos = List.unmodifiable(todos);

  // final không ngăn list.add(); List.unmodifiable mới chặn sửa nội dung list.
  final List<Todo> todos;
  final TodoFilter filter;
  final String query;

  // State suy ra: tính từ nguồn gốc, không giữ thêm một notifier dễ lệch dữ liệu.
  int get remainingCount => todos.where((todo) => !todo.isCompleted).length;
  int get completedCount => todos.length - remainingCount;

  List<Todo> get visibleTodos {
    final keyword = query.trim().toLowerCase();
    return todos
        .where((todo) {
          final matchesFilter = switch (filter) {
            TodoFilter.all => true,
            TodoFilter.active => !todo.isCompleted,
            TodoFilter.completed => todo.isCompleted,
          };
          return matchesFilter && todo.title.toLowerCase().contains(keyword);
        })
        .toList(growable: false);
  }

  TodoState copyWith({List<Todo>? todos, TodoFilter? filter, String? query}) {
    return TodoState(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
      query: query ?? this.query,
    );
  }
}
