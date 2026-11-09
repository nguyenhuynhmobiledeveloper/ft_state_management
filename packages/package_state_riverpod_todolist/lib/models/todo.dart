import 'package:equatable/equatable.dart';

// Kiểu dữ liệu của 1 todo
class Todo extends Equatable {
  // Hàm constructor của clas
  const Todo({required this.id, required this.title, this.isCompleted = false});

  final String id;
  final String title;
  final bool isCompleted;

  // Hàm copyWith để tạo 1 đối tượnh todo mới với 1 vài thuộc tính được thay đổi
  Todo copyWith({String? title, bool? isCompleted}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Hàm tạo chuỗi stringJson từ 1 đối tượng
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
  };

  // Hàm tạo 1 đối tượng todo từ chuỗi json
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted];
}
