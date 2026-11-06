import 'package:equatable/equatable.dart';
import '../models/todo.dart';

// Kiểu dữ liệu của state filter
enum TodoFilter { all, active, completed }

// State các của danh sách todo
class TodoState extends Equatable {
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

  // visibleTodos : đang là 1 getter
  // get khai báo logic lấy giá trị, nhưng cho phép truy cập 1 field , không cần dấu ()
  // Getter này không lưu sẵn kết quả và không tự ghi nhớ kết quả giữa các lần đọc.
  // Hàm trả ra danh sách todo dựa theo giá trị của state filter
  List<Todo> get visibleTodos => switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.active => todos.where((todo) => !todo.isCompleted).toList(),
    TodoFilter.completed => todos.where((todo) => todo.isCompleted).toList(),
  };
  // Hàm đếm tổng số lượng todo chưa hoàn thành
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

  @override
  List<Object?> get props => [todos, filter, isLoading, errorMessage];
}
