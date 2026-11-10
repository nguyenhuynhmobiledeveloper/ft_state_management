import 'package:equatable/equatable.dart';

/// Một công việc. Object bất biến: khi đổi trạng thái, tạo Todo mới bằng copyWith.
class Todo extends Equatable {
  const Todo({required this.id, required this.title, this.isCompleted = false});

  final String id;
  final String title;
  final bool isCompleted;

  /// Giữ nguyên id; chỉ thay những thuộc tính được truyền vào.
  Todo copyWith({String? title, bool? isCompleted}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Tạo kiểu dữ liệu dạng giống Object : key - value
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
  };

  /// Công việc lưu từ bản cũ có thể thiếu isCompleted; mặc định là false.
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  /// Equatable dùng các trường này khi so sánh hai công việc theo giá trị.
  @override
  List<Object?> get props => [id, title, isCompleted];
}
