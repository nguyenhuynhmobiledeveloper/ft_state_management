// File định nghĩa tất cả các States cho TodoBloc
// States đại diện cho trạng thái hiện tại của ứng dụng
import 'package:equatable/equatable.dart';
import '../models/todo.dart';

// Base class cho tất cả TodoStates
// Sử dụng Equatable để BLoC có thể so sánh states và quyết định rebuild widget
abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object?> get props => [];
}

// Các class dưới chính là các trạng thái tồn tại khác nhau của state trong bloc
// State: Trạng thái khởi tạo ban đầu
class TodoInitialState extends TodoState {
  const TodoInitialState();
}

// State: Đang load dữ liệu
class TodoLoadingState extends TodoState {
  const TodoLoadingState();
}

// State: Load thành công, chứa danh sách todos
class TodoLoadedState extends TodoState {
  // Chứa danh sách todo
  final List<Todo> todos;

  const TodoLoadedState(this.todos);

  @override
  List<Object?> get props => [todos];
}

// State: Có lỗi xảy ra
class TodoErrorState extends TodoState {
  final String message;

  const TodoErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// State: Đang thực hiện một thao tác operation (add, update, delete...)
// Kế thừa từ TodoLoadedState để vẫn hiển thị danh sách todos trong khi xử lý
class TodoOperationInProgressState extends TodoLoadedState {
  const TodoOperationInProgressState(super.todos);
}

// State: Thể hiện thao tác thay đổi danh sách todo đã Operation thành công + kèm 1 tin nhắn
// Danh sách todo mới hiện tại là tham số todo vừa được khởi tạo
class TodoOperationSuccessState extends TodoLoadedState {
  final String message;

  const TodoOperationSuccessState(super.todos, this.message);

  @override
  List<Object?> get props => [todos, message];
}
