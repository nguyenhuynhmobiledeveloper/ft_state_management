// File định nghĩa tất cả các Events cho TodoBloc
// Events là các hành động mà UI gửi đến BLoC để yêu cầu xử lý
import 'package:equatable/equatable.dart';
import '../models/todo.dart';

// Base class cho tất cả TodoEvents
// Sử dụng Equatable để BLoC có thể so sánh các events
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

// Event: Load danh sách todos từ repository
class TodoLoadRequestedEvent extends TodoEvent {
  const TodoLoadRequestedEvent();
}

// Event: Thêm todo mới vào danh sách todo
// event này nhận 2 tham số là title và description
class TodoAddedEvent extends TodoEvent {
  final String title;
  final String description;

  const TodoAddedEvent({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

// Event: Cập nhật một todo hiện có
// nhận 1 tham số là 1 đối tượng todo
class TodoUpdatedEvent extends TodoEvent {
  final Todo todo;

  const TodoUpdatedEvent(this.todo);

  @override
  List<Object?> get props => [todo];
}

// Event: Xóa một todo
class TodoDeletedEvent extends TodoEvent {
  final String todoId;

  const TodoDeletedEvent(this.todoId);

  @override
  List<Object?> get props => [todoId];
}

// Event: Toggle trạng thái completed của một todo
class TodoToggledEvent extends TodoEvent {
  final String todoId;

  const TodoToggledEvent(this.todoId);

  @override
  List<Object?> get props => [todoId];
}

// Event: Xóa tất cả todos đã hoàn thành
class TodoClearCompletedEvent extends TodoEvent {
  const TodoClearCompletedEvent();
}

// Event: Toggle tất cả todos (complete hoặc uncomplete all)
class TodoToggleAllEvent extends TodoEvent {
  const TodoToggleAllEvent();
}
