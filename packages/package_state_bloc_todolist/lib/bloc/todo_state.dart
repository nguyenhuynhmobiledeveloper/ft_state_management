import 'package:equatable/equatable.dart';
import '../models/todo.dart';

enum TodoFilter { all, active, completed }

class TodoState extends Equatable {
  const TodoState({
    this.todos = const [],
    this.filter = TodoFilter.all,
    this.isLoading = true,
    this.errorMessage,
  });

  final List<Todo> todos;
  final TodoFilter filter;
  final bool isLoading;
  final String? errorMessage;

  List<Todo> get visibleTodos => switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.active => todos.where((todo) => !todo.isCompleted).toList(),
    TodoFilter.completed => todos.where((todo) => todo.isCompleted).toList(),
  };

  int get remainingCount => todos.where((todo) => !todo.isCompleted).length;

  TodoState copyWith({
    List<Todo>? todos,
    TodoFilter? filter,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [todos, filter, isLoading, errorMessage];
}
