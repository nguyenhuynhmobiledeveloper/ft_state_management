import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/todo.dart';
import '../repositories/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  // Constructor của class
  TodoBloc({required TodoRepository repository})
    : _repository = repository,
      super(const TodoState()) {
    on<TodoEvent>(
      _onEvent,
      transformer: sequential(),
    ); // Các event sẽ được xử lý 1 cách tuần tự
  }

  // Phần trong thân constructor thì khai báo hàm bloc

  // Phần sau dấu : là initializer list của constructor
  //  _repository = repository, => gán field _repository bằng tham số được truyền vào
  //  super(const TodoState())  => mục gọi constructor lớp cha cũng là 1 mục của initializer list
  // Dùng một handler để mọi loại event được xử lý tuần tự.
  // Tất cả mọi event đều được xử lý trong hàm _onEvent

  // Thuộc tính trong class
  final TodoRepository _repository;

  // Mỗi event khác nhau sẽ chạy các hàm thay đổi state khác nhau
  Future<void> _onEvent(TodoEvent event, Emitter<TodoState> emit) async {
    // Nếu sự kiện là TodosRequested thì xử lý
    // event sự kiện lấy danh sách todo lên để hiển thị
    if (event is TodosRequested) {
      emit(state.copyWith(isLoading: true)); // Bắn state lên trên UI
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

    // Nếu sự kiện là TodoFilterChanged thì xử lý
    if (event is TodoFilterChanged) {
      emit(state.copyWith(filter: event.filter));
      // Bắn ra ui giá trị mới của filter
      return;
    }

    // Danh sách todo được upadate
    List<Todo>? updatedTodos;

    // Nếu event là thêm todo vào danh sách
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
    }
    // Nếu event là thay đổi trạng thái của 1 todo
    else if (event is TodoToggled) {
      updatedTodos = state.todos.map((todo) {
        if (todo.id != event.id) return todo;
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }).toList();
    } else if (event is TodoDeleted) {
      updatedTodos = state.todos.where((todo) => todo.id != event.id).toList();
    }

    if (updatedTodos == null) return;

    try {
      await _repository.saveTodos(updatedTodos);
      emit(state.copyWith(todos: updatedTodos));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Không thể lưu thay đổi.'));
    }
  }
}
