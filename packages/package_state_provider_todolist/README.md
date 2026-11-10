# package_state_provider_todolist

Ứng dụng To-Do List dùng [`provider`](https://pub.dev/packages/provider), giữ cùng bố cục, thao tác và định dạng dữ liệu với bản BLoC và Riverpod. Quy tắc chức năng nằm trong [FUNCTIONAL_SPEC.md](../package_state_bloc_todolist/FUNCTIONAL_SPEC.md).

Chạy từ thư mục gốc của repo:

```sh
flutter pub get
flutter run -t lib/main_provider_todolist.dart
```

## Cách state đi qua ứng dụng

1. `TodoApp` dùng `Provider<TodoRepository>.value` đưa repository sẵn có vào cây widget. `ChangeNotifierProvider<TodoProvider>` tạo controller và tự hủy nó khi không còn được dùng.
2. `TodoProvider` giữ một `TodoState`. Các hàm `loadTodos`, `addTodo`, `toggleTodo`, `deleteTodo`, `changeFilter` là nơi duy nhất thay state. Sau khi tạo state mới, controller gọi `notifyListeners()`.
3. `TodoScreen` dùng `Consumer<TodoProvider>` để vẽ lại theo state. Các nút dùng `context.read<TodoProvider>()` để gọi hàm mà không tạo thêm listener. Listener riêng hiển thị `SnackBar` khi state mang lỗi.
4. Mọi thao tác được nối vào một hàng đợi `Future`, nên lần ghi sau chờ lần ghi trước. Danh sách trên màn hình chỉ đổi sau khi lưu thành công.

| Bản Riverpod                                   | Bản Provider                                |
| ---------------------------------------------- | ------------------------------------------- |
| `NotifierProvider<TodoNotifier, TodoState>`    | `ChangeNotifierProvider<TodoProvider>`      |
| `ref.watch(todoProvider)`                      | `Consumer<TodoProvider>`                    |
| `ref.read(todoProvider.notifier).addTodo(...)` | `context.read<TodoProvider>().addTodo(...)` |
| Gán `state = state.copyWith(...)`              | Gán `_state` rồi gọi `notifyListeners()`    |

Ba bản dùng chung khóa `todos` trong `SharedPreferencesAsync` và cùng cấu trúc JSON (`id`, `title`, `isCompleted`). Tiêu đề của bản này dùng chữ “Provider” để dễ phân biệt ứng dụng đang chạy.
