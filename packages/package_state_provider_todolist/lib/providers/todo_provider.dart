import 'package:flutter/foundation.dart';

import '../models/todo.dart';
import '../repositories/todo_repository.dart';
import 'todo_state.dart';

/// ChangeNotifier: Đối tương thông báo khi state thay đổi -> là đối tượng mà package `provider` có thể theo dõi.
/// TodoProvider giữ state hiện tại, xử lý các thao tác, rồi gọi notifyListeners() để Consumer vẽ lại giao diện.
/// TodoState chứa dữ liệu bất biến.
class TodoProvider extends ChangeNotifier {
  TodoProvider({required TodoRepository repository}) : _repository = repository;

  // Biến kho lưu trữ
  final TodoRepository _repository;

  // Dữ liệu state đang được quản lý
  TodoState _state = const TodoState();

  // Biến để chắc chắn các event được thao tác tuần tự
  Future<void> _pending = Future<void>.value();
  bool _isDisposed = false;

  /// UI chỉ đọc state; mọi thay đổi phải đi qua các hàm bên dưới.
  TodoState get state => _state;

  /// Gắn thao tác mới sau thao tác trước, kể cả khi thao tác trước đang chờ I/O.
  /// Nhờ vậy hai lần nhấn Thêm liên tiếp không cùng đọc một danh sách cũ.
  Future<void> _enqueue(Future<void> Function() operation) {
    final result = _pending.then((_) async {
      if (!_isDisposed) await operation();
    });
    _pending = result;
    return result;
  }

  /// Chỉ phát thông báo nếu state thực sự thay đổi.
  ///  Equatable trong TodoState cho phép so sánh theo giá trị, tương tự cách BLoC tránh phát state trùng.
  /// Giả lập 1 cái emit giống như kiểu bloc
  void _emit(TodoState next) {
    if (_isDisposed || next == _state) return;
    _state = next; // Gán state bằng giá trị mới

    // notifyListeners : Thông báo rằng State đã thay đổi, Những Widget dang lắng nghe hãy rebuild
    notifyListeners();
  }

  /// Tải danh sách lúc mở màn hình hoặc khi muốn tải lại thủ công.
  Future<void> loadTodos() => _enqueue(() async {
    _emit(_state.copyWith(isLoading: true));
    try {
      final todos = await _repository.loadTodos();
      _emit(_state.copyWith(todos: todos, isLoading: false));
    } catch (_) {
      _emit(
        _state.copyWith(
          isLoading: false,
          errorMessage: 'Không thể tải danh sách công việc.',
        ),
      );
    }
  });

  /// Bộ lọc chỉ đổi phần hiển thị; không ghi SharedPreferences.
  Future<void> changeFilter(TodoFilter filter) => _enqueue(() async {
    _emit(_state.copyWith(filter: filter));
  });

  /// Bỏ qua chuỗi rỗng; công việc mới được thêm vào cuối danh sách.
  Future<void> addTodo(String title) => _enqueue(() async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return;

    await _saveTodos([
      ..._state.todos,
      Todo(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: trimmedTitle,
      ),
    ]);
  });

  /// Tạo danh sách mới với trạng thái hoàn thành của công việc được đảo lại.
  Future<void> toggleTodo(String id) => _enqueue(() async {
    await _saveTodos(
      _state.todos.map((todo) {
        if (todo.id != id) return todo;
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }).toList(),
    );
  });

  /// Loại công việc có id tương ứng, giữ thứ tự các công việc còn lại.
  Future<void> deleteTodo(String id) => _enqueue(() async {
    await _saveTodos(_state.todos.where((todo) => todo.id != id).toList());
  });

  /// Ghi toàn bộ danh sách trước rồi mới cập nhật UI. Nếu ghi lỗi, state.todos
  /// vẫn là danh sách cũ; errorMessage được màn hình dùng để hiện SnackBar.
  Future<void> _saveTodos(List<Todo> todos) async {
    try {
      await _repository.saveTodos(todos);
      _emit(_state.copyWith(todos: todos));
    } catch (_) {
      _emit(_state.copyWith(errorMessage: 'Không thể lưu thay đổi.'));
    }
  }

  @override
  void dispose() {
    // Future đang chờ có thể hoàn tất sau khi màn hình đóng.
    // _emit sẽ bỏ qua kết quả đó, tránh gọi notifyListeners() trên ChangeNotifier đã dispose.
    _isDisposed = true;
    super.dispose();
  }
}
