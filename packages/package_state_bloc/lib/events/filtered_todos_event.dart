// File định nghĩa các Events cho FilteredTodosBloc.
import 'package:equatable/equatable.dart';

import '../models/todo.dart';
import '../models/todo_filter.dart';

abstract class FilteredTodosEvent extends Equatable {
  const FilteredTodosEvent();

  @override
  List<Object?> get props => [];
}

// Event được trigger khi TodoBloc, FilterBloc hoặc SearchBloc thay đổi.
class FilteredTodosUpdatedEvent extends FilteredTodosEvent {
  final List<Todo> todos;
  final TodoFilter filter;
  final String searchQuery;

  const FilteredTodosUpdatedEvent({
    required this.todos,
    required this.filter,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [todos, filter, searchQuery];
}
