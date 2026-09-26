// Test cơ bản cho các BLoCs
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_blocs/todo_blocs.dart';
import 'package:todo_core/todo_core.dart';
import 'package:todo_events_states/todo_events_states.dart';

void main() {
  group('FilterBloc', () {
    blocTest<FilterBloc, FilterState>(
      'emits new state when FilterChanged is added',
      build: () => FilterBloc(),
      act: (bloc) => bloc.add(const FilterChanged(TodoFilter.active)),
      expect: () => [const FilterState(TodoFilter.active)],
    );
  });

  group('SearchBloc', () {
    blocTest<SearchBloc, SearchState>(
      'emits new state when SearchQueryCleared is added',
      build: () => SearchBloc(),
      act: (bloc) => bloc.add(const SearchQueryCleared()),
      expect: () => [const SearchState('')],
    );
  });

  group('TodoBloc', () {
    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] when TodoLoadRequested is added',
      build: () => TodoBloc(repository: TodoRepository()),
      act: (bloc) => bloc.add(const TodoLoadRequested()),
      wait: const Duration(seconds: 2),
      expect: () => [
        const TodoLoading(),
        predicate<TodoLoaded>((state) => state.todos.isEmpty),
      ],
    );
  });
}