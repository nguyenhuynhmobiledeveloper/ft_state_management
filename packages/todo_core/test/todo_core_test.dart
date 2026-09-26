// Test cơ bản cho TodoRepository
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_core/todo_core.dart';

void main() {
  group('TodoRepository', () {
    late TodoRepository repository;

    setUp(() {
      repository = TodoRepository();
    });

    test('initial state should be empty list', () async {
      final todos = await repository.getTodos();
      expect(todos, isEmpty);
    });

    test('should add a new todo', () async {
      final newTodo = Todo(
        id: '1',
        title: 'Test Todo',
        description: 'Test Description',
        createdAt: DateTime.now(),
      );
      final added = await repository.addTodo(newTodo);
      expect(added.title, 'Test Todo');
      expect(added.id, '1');
    });

    test('should toggle a todo', () async {
      final newTodo = Todo(
        id: '1',
        title: 'Test',
        description: 'Desc',
        createdAt: DateTime.now(),
      );
      await repository.addTodo(newTodo);
      final toggled = await repository.toggleTodo('1');
      expect(toggled.isCompleted, isTrue);
    });

    test('should delete a todo', () async {
      final newTodo = Todo(
        id: '1',
        title: 'Test',
        description: 'Desc',
        createdAt: DateTime.now(),
      );
      await repository.addTodo(newTodo);
      await repository.deleteTodo('1');
      final todos = await repository.getTodos();
      expect(todos, isEmpty);
    });
  });

  group('Todo model', () {
    test('copyWith should update fields correctly', () {
      final original = Todo(
        id: '1',
        title: 'Original',
        description: 'Desc',
        createdAt: DateTime(2024, 1, 1),
      );

      final updated = original.copyWith(title: 'Updated');

      expect(updated.title, 'Updated');
      expect(updated.id, '1'); // unchanged
      expect(updated.description, 'Desc'); // unchanged
    });

    test('two todos with same data should be equal', () {
      final date = DateTime(2024, 1, 1);
      final todo1 = Todo(
        id: '1',
        title: 'Test',
        description: 'Desc',
        createdAt: date,
      );
      final todo2 = Todo(
        id: '1',
        title: 'Test',
        description: 'Desc',
        createdAt: date,
      );
      expect(todo1, equals(todo2));
    });
  });
}