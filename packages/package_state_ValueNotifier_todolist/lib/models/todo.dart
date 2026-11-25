/// Model bất biến: thay vì sửa isCompleted, hãy tạo Todo mới bằng copyWith.
class Todo {
  const Todo({required this.id, required this.title, this.isCompleted = false});

  final int id;
  final String title;
  final bool isCompleted;

  Todo copyWith({bool? isCompleted}) {
    return Todo(
      id: id,
      title: title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
