import 'package:equatable/equatable.dart';
import 'todo_state.dart';

// class chung của các event làm việc với bloc todo
sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

// event yêu cầu lấy danh sách todo
final class TodosRequested extends TodoEvent {
  const TodosRequested();
}

// event thêm todo vào danh sách todo
final class TodoAdded extends TodoEvent {
  const TodoAdded(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
  // Đoạn này dùng để khai báo những thuộc tính được dùng để so sánh 2 event có bằng nhau hay không
}

// event thay đổi 1 trạng thái của một todo
final class TodoToggled extends TodoEvent {
  const TodoToggled(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

// event để xoá 1 todo ra khỏi danh sách
final class TodoDeleted extends TodoEvent {
  const TodoDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

// event thay đổi giá trị của state filer
final class TodoFilterChanged extends TodoEvent {
  const TodoFilterChanged(this.filter);

  final TodoFilter filter;

  @override
  List<Object?> get props => [filter];
}
