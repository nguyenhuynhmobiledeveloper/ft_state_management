import 'package:equatable/equatable.dart';

import '../models/todo.dart';

/// Ba cách xem cùng một danh sách công việc đã lưu.
enum TodoFilter { all, active, completed }

/// Ảnh chụp trạng thái tại một thời điểm. TodoProvider thay cả object khi
/// state đổi, còn widget chỉ đọc các giá trị từ object này.
class TodoState extends Equatable {
  const TodoState({
    this.todos = const [],
    this.filter = TodoFilter.all,
    this.isLoading = true,
    this.errorMessage,
  });

  final List<Todo> todos;
  final TodoFilter filter;
  final bool isLoading;
  final String? errorMessage;

  /// Chỉ lọc để hiển thị; thứ tự và nội dung todos gốc không đổi.
  List<Todo> get visibleTodos => switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.active => todos.where((todo) => !todo.isCompleted).toList(),
    TodoFilter.completed => todos.where((todo) => todo.isCompleted).toList(),
  };

  /// Bộ đếm luôn tính trên toàn bộ danh sách, không phụ thuộc bộ lọc.
  int get remainingCount => todos.where((todo) => !todo.isCompleted).length;

  /// Tạo state mới từ state cũ. Không truyền errorMessage sẽ xóa lỗi cũ, để
  /// SnackBar chỉ xuất hiện cho lần thao tác phát sinh lỗi.
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

  /// Equatable giúp TodoProvider bỏ qua những lần phát state trùng giá trị.
  @override
  List<Object?> get props => [todos, filter, isLoading, errorMessage];
}
