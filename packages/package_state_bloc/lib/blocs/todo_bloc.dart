import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../events/todo_event.dart';
import '../states/todo_state.dart';
import '../repositories/todo_repository.dart';
import '../models/todo.dart';

// TodoBloc - BLoC  quản lý danh sách todos
// Định nghĩa khi nhận được event nào thì sẽ chạy hàm handler state nào
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  // Constructor: Inject repository dependency vào BLoC
  // Initial state là TodoInitialState : khởi tạo state ban đầu là TodoInitialState()
  TodoBloc({required this.repository}) : super(const TodoInitialState()) {
    // Đăng ký các event handlers
    // Mỗi event sẽ có một handler tương ứng

    // Handler cho TodoLoadRequestedEvent
    on<TodoLoadRequestedEvent>(
      _onLoadRequested,
      transformer: restartable(),
    );
    // Sử dụng restartable transformer: nếu event mới được gửi trong khi đang xử lý
    // => cancel operation cũ và bắt đầu operation mới

    // Handler cho TodoAddedEvent
    on<TodoAddedEvent>(_onTodoAdded);

    // Handler cho TodoUpdatedEvent
    on<TodoUpdatedEvent>(_onTodoUpdated);

    // Handler cho TodoDeletedEvent
    on<TodoDeletedEvent>(_onTodoDeleted);

    // Handler cho TodoToggledEvent
    on<TodoToggledEvent>(_onTodoToggled);

    // Handler cho TodoClearCompletedEvent
    on<TodoClearCompletedEvent>(_onClearCompleted);

    // Handler cho TodoToggleAllEvent
    on<TodoToggleAllEvent>(_onToggleAll);
  }

  // Handler: Load todos từ repository
  Future<void> _onLoadRequested(
    TodoLoadRequestedEvent event,
    Emitter<TodoState> emit,
  ) async {
    // Emit loading state
    emit(const TodoLoadingState());

    try {
      // Gọi repository để lấy dữ liệu
      final todos = await repository.getTodos();

      // Emit lấy dữ liệu danh sách todo thành công từ repository
      emit(TodoLoadedState(todos));
    } catch (error) {
      // Emit error state nếu có lỗi
      emit(TodoErrorState(error.toString()));
    }
  }

  // Handler: Thêm todo mới vào danh sách todo
  Future<void> _onTodoAdded(
    TodoAddedEvent event,
    Emitter<TodoState> emit,
  ) async {
    // Chỉ xử lý khi state hiện tại là TodoLoadedState
    if (state is! TodoLoadedState) return;

    // Danh sách todo === state hiện tại
    final currentState = state as TodoLoadedState;

    // Emit operation in progress
    emit(TodoOperationInProgressState(currentState.todos));

    try {
      // Tạo todo mới
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        description: event.description,
        createdAt: DateTime.now(),
      );

      // Thêm vào repository
      await repository.addTodo(newTodo);

      // Lấy lại danh sách todos mới
      final updatedTodos = await repository.getTodos();

      // Emit success state - cập nhật danh sách todo mới trong state của bloc
      emit(TodoOperationSuccessState(updatedTodos, 'Thêm todo thành công'));
    } catch (error) {
      // Trong trường hợp thêm thất bại thì vẫn giữ danh sách todo cũ
      emit(TodoErrorState(error.toString()));
      emit(TodoLoadedState(currentState.todos));
    }
  }

  // Handler: Cập nhật todo
  Future<void> _onTodoUpdated(
    TodoUpdatedEvent event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoadedState) return;

    final currentState = state as TodoLoadedState;
    emit(TodoOperationInProgressState(currentState.todos));

    try {
      await repository.updateTodo(event.todo);
      final updatedTodos = await repository.getTodos();
      emit(TodoOperationSuccessState(updatedTodos, 'Cập nhật todo thành công'));
    } catch (error) {
      emit(TodoErrorState(error.toString()));
      emit(TodoLoadedState(currentState.todos));
    }
  }

  // Handler: Xóa todo
  Future<void> _onTodoDeleted(
    TodoDeletedEvent event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoadedState) return;

    final currentState = state as TodoLoadedState;
    emit(TodoOperationInProgressState(currentState.todos));

    try {
      await repository.deleteTodo(event.todoId);
      final updatedTodos = await repository.getTodos();
      emit(TodoOperationSuccessState(updatedTodos, 'Xóa todo thành công'));
    } catch (error) {
      emit(TodoErrorState(error.toString()));
      emit(TodoLoadedState(currentState.todos));
    }
  }

  // Handler: Toggle trạng thái todo
  Future<void> _onTodoToggled(
    TodoToggledEvent event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoadedState) return;

    final currentState = state as TodoLoadedState;

    try {
      await repository.toggleTodo(event.todoId);
      final updatedTodos = await repository.getTodos();

      // Không cần hiển thị success message cho toggle
      emit(TodoLoadedState(updatedTodos));
    } catch (error) {
      emit(TodoErrorState(error.toString()));
      emit(TodoLoadedState(currentState.todos));
    }
  }

  // Handler: Xóa tất cả todos đã hoàn thành
  Future<void> _onClearCompleted(
    TodoClearCompletedEvent event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoadedState) return;

    final currentState = state as TodoLoadedState;
    emit(TodoOperationInProgressState(currentState.todos));

    try {
      await repository.clearCompleted();
      final updatedTodos = await repository.getTodos();
      emit(TodoOperationSuccessState(updatedTodos, 'Đã xóa todos hoàn thành'));
    } catch (error) {
      emit(TodoErrorState(error.toString()));
      emit(TodoLoadedState(currentState.todos));
    }
  }

  // Handler: Toggle tất cả todos
  Future<void> _onToggleAll(
    TodoToggleAllEvent event,
    Emitter<TodoState> emit,
  ) async {
    if (state is! TodoLoadedState) return;

    final currentState = state as TodoLoadedState;
    emit(TodoOperationInProgressState(currentState.todos));

    try {
      final todos = currentState.todos;

      // Kiểm tra xem tất cả todos đã completed chưa
      final allCompleted = todos.every((todo) => todo.isCompleted);

      // Toggle tất cả todos
      for (final todo in todos) {
        if (allCompleted) {
          // Nếu tất cả đã completed, uncomplete tất cả
          if (todo.isCompleted) {
            await repository.toggleTodo(todo.id);
          }
        } else {
          // Nếu chưa, complete tất cả
          if (!todo.isCompleted) {
            await repository.toggleTodo(todo.id);
          }
        }
      }

      final updatedTodos = await repository.getTodos();
      emit(TodoLoadedState(updatedTodos));
    } catch (error) {
      emit(TodoErrorState(error.toString()));
      emit(TodoLoadedState(currentState.todos));
    }
  }
}
