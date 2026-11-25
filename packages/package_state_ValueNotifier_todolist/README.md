# To-do List với ValueNotifier

Package độc lập được tách từ `package_state_ValueNotifier`. Giữ nguyên model,
controller và màn hình To-do; chỉ dùng Flutter SDK, không dùng thư viện quản lý
state và không phụ thuộc vào package các ví dụ cơ bản.

Tên thư mục là `package_state_ValueNotifier_todolist`. Tên dùng trong
`pubspec.yaml` và import Dart là `package_state_value_notifier_todolist`.

## Chạy trong project BUFF_V2

Từ thư mục gốc:

```sh
flutter pub get
flutter run -t lib/main_value_notifier_todolist.dart
```

Package dùng các thư mục nền tảng của ứng dụng gốc để chạy.

## Sử dụng trong ứng dụng Flutter khác

```yaml
dependencies:
  package_state_value_notifier_todolist:
    path: ../BUFF_V2/packages/package_state_ValueNotifier_todolist
```

```dart
import 'package:package_state_value_notifier_todolist/package_state_value_notifier_todolist.dart';

void main() => runPackageStateValueNotifierTodolistApp();
```

Cũng có thể dùng `const TodoScreen()` bên trong `MaterialApp` hiện có.

## Cấu trúc và thứ tự đọc

```text
lib/
├── models/
│   ├── todo.dart
│   └── todo_state.dart
├── controllers/
│   └── todo_controller.dart
├── screens/
│   └── todo_screen.dart
├── main.dart
└── package_state_value_notifier_todolist.dart
```

1. [todo.dart](lib/models/todo.dart): model bất biến, dùng `copyWith` khi thay đổi
   trạng thái hoàn thành.
2. [todo_state.dart](lib/models/todo_state.dart): gom danh sách, bộ lọc và từ khóa
   tìm kiếm vào một snapshot; tính số đếm và danh sách hiển thị bằng getter.
3. [todo_controller.dart](lib/controllers/todo_controller.dart): kế thừa
   `ValueNotifier<TodoState>`, cung cấp các thao tác thêm, hoàn thành, xóa,
   đổi bộ lọc, tìm kiếm và xóa những việc đã xong.
4. [todo_screen.dart](lib/screens/todo_screen.dart): dùng
   `ValueListenableBuilder<TodoState>` cập nhật UI và `TextEditingController`
   đọc ô nhập; màn hình sở hữu và dispose các controller.

Danh sách bên trong state được bọc bằng `List.unmodifiable`, các phần tử có
field `final`. Mỗi thao tác thay đổi dữ liệu tạo snapshot mới rồi gán vào
`value`; không sửa trực tiếp danh sách hoặc object của snapshot cũ.

Dữ liệu chỉ giữ trong bộ nhớ, khởi tạo lại khi màn hình bị hủy rồi mở lại.

## Kiểm tra mã nguồn

```sh
cd packages/package_state_ValueNotifier_todolist
flutter pub get
flutter analyze
```

Các ví dụ ValueNotifier cơ bản vẫn ở
[package_state_ValueNotifier](../package_state_ValueNotifier/README.md).
