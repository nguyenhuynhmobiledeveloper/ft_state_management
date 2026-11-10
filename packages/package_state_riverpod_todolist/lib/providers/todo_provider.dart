import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';
import '../repositories/todo_repository.dart';
import 'todo_state.dart';

// Đây là 1 cái kho cung cấp -> Provider : Dạng Provider có giá trị cố định - thường dùng cho dependency inject
// Có thể thay giá trị mặc định bằng overrideWithValue trong ProviderScope.
final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(),
);

// Đây là cái kho cung cấp kiểu - NotifierProvider : dạng các state có thay đổi logic phức tạp bên trong
// NotifierProvider<TodoNotifier, TodoState> tạo notifier và phát state cho widget theo dõi.
final todoProvider = NotifierProvider<TodoNotifier, TodoState>(
  TodoNotifier.new,
);

/// TodoNotifier quản lý TodoState và tập trung các thao tác thay đổi danh sách todo.
/// ref, state và build là API có sẵn do Notifier của Riverpod cung cấp.
class TodoNotifier extends Notifier<TodoState> {
  // Future này nối các thao tác để tránh ghi dữ liệu chồng lên nhau.
  Future<void> _pending = Future<void>.value();

  /// build trả về state ban đầu khi Riverpod tạo TodoNotifier.
  @override
  TodoState build() => const TodoState();

  /// _enqueue xếp thao tác vào hàng đợi và chỉ chạy khi notifier còn hoạt động.
  Future<void> _enqueue(Future<void> Function() operation) {
    final result = _pending.then((_) async {
      // ref.mounted cho biết notifier vẫn còn trong vòng đời của provider.
      if (ref.mounted) await operation();
    });
    // Each operation handles its own storage error; keep the queue usable.
    // Mỗi thao tác tự xử lý lỗi lưu trữ của chính nó
    // Hãy giữ cho hàng đợi luôn ở trạng thái có thể sử dụng được
    _pending = result;
    return result;
  }

  /// loadTodos đọc repository qua ref.read rồi cập nhật state để màn hình vẽ lại.
  Future<void> loadTodos() => _enqueue(() async {
    // Phát trạng thái loading ở view luôn
    state = state.copyWith(isLoading: true);
    try {
      // Lấy ra danh sách todo đang được lưu ở storage shared
      final todos = await ref.read(todoRepositoryProvider).loadTodos();
      if (!ref.mounted) return;
      state = state.copyWith(todos: todos, isLoading: false);
    } catch (_) {
      if (!ref.mounted) return;
      // Nếu mà lỗi không lấy được danh sách thì cập nhật loading + text báo lỗi
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tải danh sách công việc.',
      );
    }
  });

  /// changeFilter đổi bộ lọc trong state; danh sách gốc không thay đổi.
  Future<void> changeFilter(TodoFilter filter) => _enqueue(() async {
    state = state.copyWith(filter: filter);
  });

  /// addTodo thêm công việc mới sau khi bỏ khoảng trắng thừa và lưu dữ liệu.
  Future<void> addTodo(String title) => _enqueue(() async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return;

    final todo = Todo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: trimmedTitle,
    );

    await _saveTodos([...state.todos, todo]);
  });

  /// toggleTodo đảo trạng thái hoàn thành của công việc có id tương ứng.
  Future<void> toggleTodo(String id) => _enqueue(() async {
    await _saveTodos(
      state.todos.map((todo) {
        if (todo.id != id) return todo;
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }).toList(),
    );
  });

  /// deleteTodo xóa công việc có id tương ứng rồi lưu danh sách mới.
  Future<void> deleteTodo(String id) => _enqueue(() async {
    await _saveTodos(state.todos.where((todo) => todo.id != id).toList());
  });

  /// _saveTodos ghi danh sách qua todoRepositoryProvider trước khi phát state mới.
  Future<void> _saveTodos(List<Todo> todos) async {
    try {
      // Chạy hàm saveTodos của todoRepositoryProvider ==> lưu dữ liệu và storage
      await ref.read(todoRepositoryProvider).saveTodos(todos);
      if (!ref.mounted) return;
      // Lưu trữ xong thì mới thay đổi state để UI update
      state = state.copyWith(todos: todos);
    } catch (_) {
      if (!ref.mounted) return;
      state = state.copyWith(errorMessage: 'Không thể lưu thay đổi.');
    }
  }
}
