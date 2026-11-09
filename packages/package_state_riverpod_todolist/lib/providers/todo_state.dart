import 'package:equatable/equatable.dart';
import '../models/todo.dart';

// Kiểu dữ liệu của state filter
// TodoFilter xác định nhóm công việc được hiển thị: tất cả, chưa xong hoặc đã xong.
enum TodoFilter { all, active, completed }

// State các của danh sách todo
// TodoState gom các giá trị trạng thái mà todoProvider phát cho widget đang theo dõi.
// Equatable giúp so sánh hai state theo giá trị của các thuộc tính trong props.
class TodoState extends Equatable {
  // Constructor đặt giá trị mặc định cho danh sách, bộ lọc và trạng thái tải.
  const TodoState({
    this.todos = const [],
    this.filter = TodoFilter.all,
    this.isLoading = true,
    this.errorMessage,
  });

  // State gồm các filed sau - là 1 field - biến thuộc về object
  final List<Todo> todos;
  final TodoFilter filter;
  final bool isLoading;
  final String? errorMessage;

  // Biến dạng getter - trả ra danh sách todo dựa theo trạng thái của state filter
  List<Todo> get visibleTodos => switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.active => todos.where((todo) => !todo.isCompleted).toList(),
    TodoFilter.completed => todos.where((todo) => todo.isCompleted).toList(),
  };
  // Hàm đếm tổng số lượng todo chưa hoàn thành
  // remainingCount là getter tính số công việc chưa hoàn thành từ danh sách gốc.
  int get remainingCount => todos.where((todo) => !todo.isCompleted).length;

  // Hàm copyWith để Imutate : Đổi thành 1 object mới : giữ các thuộc tính cũ + thay đổi 1 vài thuộc tính
  TodoState copyWith({
    List<Todo>? todos,
    TodoFilter? filter,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  // props liệt kê các thuộc tính mà Equatable dùng để so sánh TodoState.
  @override
  List<Object?> get props => [todos, filter, isLoading, errorMessage];
}
