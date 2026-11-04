// File định nghĩa các States cho FilteredTodosBloc.
import 'package:equatable/equatable.dart';

import '../models/todo.dart';

abstract class FilteredTodosState extends Equatable {
  const FilteredTodosState();

  @override
  List<Object?> get props => [];
}

class FilteredTodosLoadingState extends FilteredTodosState {
  const FilteredTodosLoadingState();
}

class FilteredTodosLoadedState extends FilteredTodosState {
  final List<Todo> filteredTodos;
  final int activeCount;
  final int completedCount;

  const FilteredTodosLoadedState({
    required this.filteredTodos,
    required this.activeCount,
    required this.completedCount,
  });

  @override
  List<Object?> get props => [filteredTodos, activeCount, completedCount];
}
