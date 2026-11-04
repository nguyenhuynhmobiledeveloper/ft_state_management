import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/todo.dart';
import '../repositories/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({required TodoRepository repository})
    : _repository = repository,
      super(const TodoState()) {
    // Dùng một handler để mọi loại event được xử lý tuần tự.
    on<TodoEvent>(_onEvent, transformer: sequential());
  }

  final TodoRepository _repository;

  Future<void> _onEvent(TodoEvent event, Emitter<TodoState> emit) async {
    if (event is TodosRequested) {
      emit(state.copyWith(isLoading: true));
      try {
        final todos = await _repository.loadTodos();
        emit(state.copyWith(todos: todos, isLoading: false));
      } catch (_) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Không thể tải danh sách công việc.',
          ),
        );
      }
      return;
    }

    if (event is TodoFilterChanged) {
      emit(state.copyWith(filter: event.filter));
      return;
    }

    List<Todo>? updatedTodos;

    if (event is TodoAdded) {
      final title = event.title.trim();
      if (title.isEmpty) return;

      updatedTodos = [
        ...state.todos,
        Todo(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
        ),
      ];
    } else if (event is TodoToggled) {
      updatedTodos = state.todos.map((todo) {
        if (todo.id != event.id) return todo;
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }).toList();
    } else if (event is TodoDeleted) {
      updatedTodos = state.todos.where((todo) => todo.id != event.id).toList();
    }

    if (updatedTodos == null) return;

    try {
      // Lưu thành công rồi mới cập nhật state.
      await _repository.saveTodos(updatedTodos);
      emit(state.copyWith(todos: updatedTodos));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Không thể lưu thay đổi.'));
    }
  }
}
