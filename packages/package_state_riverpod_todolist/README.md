# package_state_riverpod_todolist

Ứng dụng To-Do List dùng Riverpod, có cùng giao diện, hành vi và định dạng lưu trữ với `package_state_bloc_todolist` theo [đặc tả chức năng](../package_state_bloc_todolist/FUNCTIONAL_SPEC.md).

Chạy từ thư mục gốc của repo:

```sh
flutter pub get
flutter run -t lib/main_riverpod_todolist.dart
```

Package dùng `NotifierProvider<TodoNotifier, TodoState>` cho state và `Provider<TodoRepository>` cho lớp lưu trữ. `TodoScreen` dùng `ref.watch` để vẽ giao diện, `ref.read` để gửi thao tác và `ref.listen` để hiện snackbar lỗi. Các thao tác trong `TodoNotifier` được xếp hàng tuần tự. Mỗi thay đổi được ghi bằng `SharedPreferencesAsync` trước khi cập nhật state trên màn hình.

Hai bản dùng chung khóa `todos` và chuỗi JSON gồm `id`, `title`, `isCompleted`, nên có thể mở luân phiên mà không cần chuyển đổi dữ liệu. Theo yêu cầu giao diện giống hệt, tiêu đề ứng dụng và AppBar vẫn giữ chữ “BLoC”.

API công khai:

```dart
import 'package:package_state_riverpod_todolist/package_state_riverpod_todolist.dart';

void main() => runPackageStateRiverpodTodolistApp();
```
