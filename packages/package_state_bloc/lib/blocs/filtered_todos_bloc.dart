// FilteredTodosBloc - BLoC kết hợp TodoBloc, FilterBloc và SearchBloc.
// Demo cách một BLoC lắng nghe và phản ứng với nhiều BLoCs khác.

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../events/filtered_todos_event.dart';
import '../models/todo.dart';
import '../models/todo_filter.dart';
import '../states/filter_state.dart';
import '../states/filtered_todos_state.dart';
import '../states/search_state.dart';
import '../states/todo_state.dart';
import 'filter_bloc.dart';
import 'search_bloc.dart';
import 'todo_bloc.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodoBloc todoBloc;
  final FilterBloc filterBloc;
  final SearchBloc searchBloc;

  late final StreamSubscription<TodoState> _todoSubscription;
  late final StreamSubscription<FilterState> _filterSubscription;
  late final StreamSubscription<SearchState> _searchSubscription;

  FilteredTodosBloc({
    required this.todoBloc,
    required this.filterBloc,
    required this.searchBloc,
  }) : super(const FilteredTodosLoadingState()) {
    on<FilteredTodosUpdatedEvent>(_onFilteredTodosUpdated);

    _todoSubscription = todoBloc.stream.listen((todoState) {
      if (todoState is TodoLoadedState) {
        _addUpdate(
          todos: todoState.todos,
          filter: filterBloc.state.filter,
          searchQuery: searchBloc.state.query,
        );
      }
    });

    _filterSubscription = filterBloc.stream.listen((filterState) {
      final todoState = todoBloc.state;
      if (todoState is TodoLoadedState) {
        _addUpdate(
          todos: todoState.todos,
          filter: filterState.filter,
          searchQuery: searchBloc.state.query,
        );
      }
    });

    _searchSubscription = searchBloc.stream.listen((searchState) {
      final todoState = todoBloc.state;
      if (todoState is TodoLoadedState) {
        _addUpdate(
          todos: todoState.todos,
          filter: filterBloc.state.filter,
          searchQuery: searchState.query,
        );
      }
    });
  }

  void _addUpdate({
    required List<Todo> todos,
    required TodoFilter filter,
    required String searchQuery,
  }) {
    add(FilteredTodosUpdatedEvent(
      todos: todos,
      filter: filter,
      searchQuery: searchQuery,
    ));
  }

  // Handler: Xử lý filtering và searching.
  void _onFilteredTodosUpdated(
    FilteredTodosUpdatedEvent event,
    Emitter<FilteredTodosState> emit,
  ) {
    var filteredTodos = event.todos;

    switch (event.filter) {
      case TodoFilter.active:
        filteredTodos =
            filteredTodos.where((todo) => !todo.isCompleted).toList();
        break;
      case TodoFilter.completed:
        filteredTodos =
            filteredTodos.where((todo) => todo.isCompleted).toList();
        break;
      case TodoFilter.all:
        break;
    }

    if (event.searchQuery.isNotEmpty) {
      final query = event.searchQuery.toLowerCase();
      filteredTodos = filteredTodos.where((todo) {
        return todo.title.toLowerCase().contains(query) ||
            todo.description.toLowerCase().contains(query);
      }).toList();
    }

    final activeCount = event.todos.where((todo) => !todo.isCompleted).length;
    final completedCount = event.todos.where((todo) => todo.isCompleted).length;

    emit(FilteredTodosLoadedState(
      filteredTodos: filteredTodos,
      activeCount: activeCount,
      completedCount: completedCount,
    ));
  }

  @override
  Future<void> close() async {
    await Future.wait([
      _todoSubscription.cancel(),
      _filterSubscription.cancel(),
      _searchSubscription.cancel(),
    ]);
    await super.close();
  }
}
