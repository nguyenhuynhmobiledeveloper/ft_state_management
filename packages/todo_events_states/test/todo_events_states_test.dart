// Test cơ bản cho events & states
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_core/todo_core.dart';
import 'package:todo_events_states/todo_events_states.dart';

void main() {
  group('TodoEvent', () {
    test('TodoAdded should hold title and description', () {
      final event = TodoAdded(title: 'Test', description: 'Desc');
      expect(event.title, 'Test');
      expect(event.description, 'Desc');
    });

    test('TodoDeleted should hold todoId', () {
      final event = TodoDeleted('id-1');
      expect(event.todoId, 'id-1');
    });
  });

  group('TodoState', () {
    test('TodoLoaded holds todos', () {
      final state = TodoLoaded(const []);
      expect(state.todos, isEmpty);
    });

    test('TodoOperationInProgress extends TodoLoaded', () {
      final state = TodoOperationInProgress(const []);
      expect(state, isA<TodoLoaded>());
    });
  });

  group('FilterState', () {
    test('default filter should be all', () {
      expect(FilterState(TodoFilter.all).filter, TodoFilter.all);
    });
  });

  group('SearchState', () {
    test('empty query is valid', () {
      expect(const SearchState('').query, '');
    });
  });
}