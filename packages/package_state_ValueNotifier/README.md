# Học ValueNotifier bằng Flutter SDK

8 ví dụ có thể bấm thử, đọc từ cơ bản đến tổng hợp. Các màn hình chỉ dùng
`package:flutter/...` và Dart SDK; không dùng thư viện quản lý state.
`flutter_test` và `flutter_lints` chỉ phục vụ kiểm tra khi phát triển.

Tên thư mục giữ đúng yêu cầu: `package_state_ValueNotifier`.
Tên package trong Dart là `package_state_value_notifier` để tuân theo quy tắc
`lowercase_with_underscores`.

## Chạy ví dụ

Từ **thư mục gốc BUFF_V2**:

```sh
flutter pub get
flutter run
```

`lib/main.dart` của project gốc hiện mở menu chọn 8 ví dụ.
Ứng dụng To-do đã được tách sang
[package_state_ValueNotifier_todolist](../package_state_ValueNotifier_todolist/README.md).

Để dùng màn hình trong một ứng dụng Flutter khác, thêm path dependency:

```yaml
dependencies:
  package_state_value_notifier:
    path: ../BUFF_V2/packages/package_state_ValueNotifier
```

```dart
import 'package:package_state_value_notifier/package_state_value_notifier.dart';

void main() => runPackageStateValueNotifierApp();
```

Package chứa code Flutter và entry point; nó dùng các thư mục nền tảng
Android/iOS/web của ứng dụng gốc để chạy, không có project nền tảng riêng.

## 1. Các class liên quan và vai trò

| Class / interface | Vai trò | Đọc ở đâu |
| --- | --- | --- |
| `Listenable` | Hợp đồng `addListener` / `removeListener`; không có `value` | 05, 06 |
| `ChangeNotifier` | Cài đặt cơ chế quản lý listener và `notifyListeners()` | Class cha của `ValueNotifier` |
| `ValueListenable<T>` | `Listenable` có getter `value`, không khai báo setter | 06, 07 |
| `ValueNotifier<T>` | Giữ một giá trị và thông báo khi gán giá trị khác theo `==` | 01, 02, 03 |
| `ValueListenableBuilder<T>` | Nghe nguồn, nhận giá trị hiện tại, dựng UI | 01–07 |
| `Listenable.merge(...)` | Gộp thông báo từ nhiều nguồn; đây là factory, không phải class mới | 05 |
| `ListenableBuilder` | Dựng UI khi một `Listenable` thông báo; tự đọc giá trị nguồn | 05 |
| `AnimatedBuilder` | Cùng cơ chế nghe `Listenable`; tên phù hợp hơn khi dùng animation | So sánh bên dưới |
| `TextEditingController` | Một `ValueNotifier<TextEditingValue>` có sẵn cho ô nhập liệu | 04 |
| `TextEditingValue` | Chứa text, vùng chọn và vùng composing của bộ gõ | 04 |
| `InheritedNotifier<T>` | Cấp một notifier cho cây widget và cập nhật các widget phụ thuộc | 08 |
| `StatefulWidget` / `State` | Giữ notifier qua các lần build và quản lý vòng đời | Các ví dụ |

Quan hệ chính: `ValueNotifier<T>` **kế thừa** `ChangeNotifier` và
**implements** `ValueListenable<T>`. `ValueListenable<T>` là một `Listenable`.
Không cần tự viết lại cơ chế quản lý listener.

`ValueNotifier` giữ **trạng thái hiện tại**, không lưu lịch sử sự kiện.
Khi vừa đăng ký bằng `addListener`, callback chưa chạy ngay; hãy đọc `.value`
nếu cần giá trị ban đầu. `ValueListenableBuilder` tự đọc giá trị ban đầu khi build.

## 2. Lộ trình đọc và bấm thử

| Ví dụ | File chính | Thử trên UI | Điều cần hiểu |
| --- | --- | --- | --- |
| 01. Counter | [example_01_counter.dart](lib/examples/example_01_counter.dart) | Tăng, giảm, gán lại cùng giá trị | `.value`, `==`, phạm vi rebuild, `child` |
| 02. Bật / tắt | [example_02_toggle.dart](lib/examples/example_02_toggle.dart) | Nhập mật khẩu, bật / tắt hiển thị | Một `bool` đủ cho state UI đơn giản |
| 03. Danh sách | [example_03_list.dart](lib/examples/example_03_list.dart) | Thêm và xóa mục | Tạo list mới thay vì sửa list đang giữ |
| 04. Ô nhập liệu | [example_04_text_input.dart](lib/examples/example_04_text_input.dart) | Nhập tên, di chuyển con trỏ, xóa nội dung | Nghe trực tiếp controller; text và selection đều có thể đổi |
| 05. Nhiều notifier | [example_05_multiple_notifiers.dart](lib/examples/example_05_multiple_notifiers.dart) | Đổi số lượng và đơn giá | Gộp nguồn, tính tổng từ giá trị hiện tại |
| 06. Listener thủ công | [example_06_manual_listener.dart](lib/examples/example_06_manual_listener.dart) | Tăng đến mốc 3, chuyển A/B | Side effect, thay nguồn listener |
| 07. Bất đồng bộ | [example_07_async.dart](lib/examples/example_07_async.dart) | Tải, giả lập lỗi, thử lại, bấm liên tiếp | State tải dữ liệu, bỏ kết quả cũ và kết quả sau dispose |
| 08. Chia sẻ state | [example_08_shared_state.dart](lib/examples/example_08_shared_state.dart) | Tăng ở hai màn hình rồi quay lại | `InheritedNotifier`, đọc một lần và theo dõi thay đổi |

Ví dụ To-do tổng hợp nằm trong package riêng:
[package_state_ValueNotifier_todolist](../package_state_ValueNotifier_todolist/README.md).

Mỗi màn hình sở hữu state riêng. Rời ví dụ về menu rồi mở lại sẽ khởi tạo lại.
Riêng hai màn hình trong ví dụ 08 chia sẻ cùng instance khi ví dụ vẫn mở.
Không có lưu dữ liệu xuống ổ đĩa; ví dụ 07 giả lập API bằng `Future.delayed`.

## 3. Luồng hoạt động tối thiểu

```dart
final count = ValueNotifier<int>(0); // 1. Tạo nguồn state một lần.

void logCount() {
  debugPrint('Giá trị hiện tại: ${count.value}');
}

count.addListener(logCount); // 2. Đăng ký callback.
count.value = 1;             // 3. 0 != 1: setter gọi notifyListeners().
count.value = 1;             // 4. 1 == 1: không thông báo lại.
count.removeListener(logCount);
count.dispose();             // 5. Chủ sở hữu giải phóng khi không dùng nữa.
```

Đây là đoạn minh họa API, đặt trong một hàm. Trong widget, xem cách phân bổ
khởi tạo và giải phóng trong `State` ở ví dụ 01 và 06.

Callback listener chạy đồng bộ khi setter thông báo. Widget builder được đánh
dấu cần build và Flutter dựng lại theo lịch khung hình; không đảm bảo mỗi phép
gán đều tạo một khung hình riêng. Không dùng notifier như hàng đợi sự kiện.

## 4. Chọn builder hay listener?

**Dựng UI:** dùng `ValueListenableBuilder<T>`. Builder nhận trực tiếp giá trị mới,
nên không cần tự `addListener` rồi `setState` chỉ để hiển thị số đếm.
Widget này quản lý đăng ký, đổi nguồn và gỡ listener của chính nó;
nó không dispose notifier do bạn truyền vào.

**Nhiều nguồn hoặc chỉ có `Listenable`:** dùng `ListenableBuilder`.
Ví dụ 05 dùng `Listenable.merge([quantity, unitPrice])` và đọc cả hai `.value`.
Nguồn gộp không tạo ra giá trị `total`, không dispose các nguồn đầu vào, và
iterable đầu vào không được thêm / xóa phần tử sau khi gọi merge.

**Animation:** `AnimatedBuilder(animation: source, builder: ...)` cũng nhận
`Listenable`, kể cả `ValueNotifier`. Trong các ví dụ state thông thường,
`ListenableBuilder` diễn đạt mục đích rõ hơn nên được dùng ở ví dụ 05.

**Hiệu ứng một lần:** dùng `addListener` cho SnackBar, ghi log hoặc thao tác điều
hướng có điều kiện. Đừng đặt các thao tác đó trong builder vì builder có thể
chạy lại do cha hoặc theme đổi, ngay cả khi bạn không vừa thay state.
Xem [counter_notice.dart](lib/widgets/counter_notice.dart).

**Phần UI cố định:** truyền vào tham số `child` để builder dùng lại cùng widget.
Phần này không được phụ thuộc vào giá trị đang nghe. `child` giúp tránh dựng lại
subtree do notifier này thay đổi; nó vẫn có thể cập nhật khi dependency riêng
như theme thay đổi. Ví dụ 01 có minh họa.

## 5. Bẫy với List, Map, Set và object

Setter của `ValueNotifier` kiểm tra `oldValue == newValue`. Nó không tự theo dõi
việc sửa field hay phần tử bên trong object.

```dart
final items = ValueNotifier<List<String>>([]);

items.value.add('A');               // Không thông báo: chưa gọi setter value.
items.value = items.value;          // Vẫn không: cùng list, == trả về true.
items.value = [...items.value, 'B']; // Có thông báo: list mới, == trả về false.
items.dispose();
```

List thông thường của Dart so sánh theo identity, không so sánh từng phần tử.
Vì vậy hai list mới có cùng nội dung vẫn thường làm notifier thông báo.
Với Map và Set cũng nên tạo bản mới:

```dart
settings.value = {...settings.value, 'darkMode': true};
selectedIds.value = {...selectedIds.value, newId};
```

Hai dòng này giả sử `settings` là `ValueNotifier<Map<String, bool>>`,
`selectedIds` là `ValueNotifier<Set<int>>` và `newId` là một `int`.

Với object riêng, dùng field `final` và `copyWith` tạo snapshot mới:

```dart
value = value.copyWith(todos: [...value.todos, newTodo]);
```

Xem [todo.dart](../package_state_ValueNotifier_todolist/lib/models/todo.dart) và
[todo_state.dart](../package_state_ValueNotifier_todolist/lib/models/todo_state.dart)
trong package To-do riêng.
`final List<Todo>` chỉ chặn gán lại biến, không chặn `.add()`;
`List.unmodifiable` trong `TodoState` mới chặn sửa nội dung danh sách.
Các phần tử `Todo` cũng bất biến để tránh sửa dữ liệu của snapshot cũ.

`TodoState` giữ phép `==` mặc định, nên mỗi instance mới là một giá trị khác.
Controller kiểm tra các thao tác không thay đổi dữ liệu trước khi tạo state mới.
Nếu tự override `==` theo nội dung, phải override `hashCode` tương ứng;
hai object được xem là bằng nhau sẽ không làm notifier thông báo.

Không cần gọi `notifyListeners()` sau khi đã gán `.value` mới: setter làm việc đó.
Nếu bài toán chủ yếu sửa dữ liệu tại chỗ và cần tự điều khiển thông báo,
có thể học tiếp cách kế thừa trực tiếp `ChangeNotifier` của Flutter SDK.

## 6. Vòng đời và quyền sở hữu

1. Khởi tạo notifier bằng field của `State` hoặc trong `initState`, không tạo trong
   `build`. Tạo trong `build` dễ mất state và để lại các instance không được dispose.
2. `initState`: đăng ký listener thủ công nếu cần. Không dùng `watch` của
   `InheritedNotifier` tại đây; dùng trong `build` / `didChangeDependencies`.
3. `didUpdateWidget`: nếu nhận nguồn từ widget cha và nguồn đổi, gỡ callback khỏi
   nguồn cũ rồi đăng ký callback trên nguồn mới.
4. `dispose`: gỡ listener thủ công. Chỉ dispose notifier do mình sở hữu;
   widget con mượn nguồn không dispose nguồn của cha.
5. Đăng ký và gỡ **cùng callback**. Hai anonymous closure viết giống nhau vẫn là
   hai đối tượng hàm khác nhau, nên không dùng closure mới để gỡ listener cũ.

Ví dụ 06 chia phần sở hữu nguồn ở màn hình và phần nghe ở `CounterNotice`.
Chuyển công tắc A/B giữ widget con nhưng thay nguồn, nên có thể xem
`didUpdateWidget` xử lý việc này.

Đừng thay state hoặc hiển thị SnackBar ngay trong `build`. Nếu cần tác vụ khởi
tạo có thông báo sau khi widget được gắn vào cây, chọn thời điểm phù hợp như
callback sau khung hình và kiểm tra `mounted` trước khi dùng context.

## 7. Hai cách tách controller

| Cách | Ví dụ | Đặc điểm |
| --- | --- | --- |
| Chứa một notifier private | [message_controller.dart](lib/controllers/message_controller.dart) | Public `ValueListenable<MessageState>` cho UI đọc/nghe; thay đổi qua `load()` |
| Kế thừa `ValueNotifier<State>` | [todo_controller.dart](../package_state_ValueNotifier_todolist/lib/controllers/todo_controller.dart) trong package To-do riêng | Ngắn gọn, truyền controller thẳng vào builder; API kế thừa vẫn có setter `value` và `dispose` |

`ValueListenable` là interface chỉ đọc giá trị, không phải bản sao dữ liệu.
UI vẫn nhận cập nhật từ cùng nguồn. Muốn giới hạn chỗ ghi state trong API thông
thường, chọn cách chứa notifier private và chỉ công khai interface này.

To-do gom `todos`, `filter`, `query` vào một `TodoState`. Khi đổi công việc,
UI nhận một snapshot nhất quán. Các số đếm và `visibleTodos` là getter suy ra,
không lưu thêm notifier nên không cần đồng bộ nhiều bản dữ liệu.

## 8. Future và kết quả trả về muộn

Ví dụ 07 giữ `initial`, `loading`, `success`, `error` trong một `MessageState`
bất biến. UI chỉ cần một builder để chọn nội dung.

`ValueNotifier` không tự hủy Future và không tự xử lý lỗi. Controller dùng:

- `_disposed`: không ghi state sau khi đã giải phóng controller.
- `_requestId`: nếu A bắt đầu trước B nhưng trả kết quả sau B, bỏ kết quả của A.
- `try/catch`: chuyển lỗi thành state để UI cho người học thử lại.

Các kiểm tra này bỏ qua kết quả không còn hợp lệ; Future giả lập vẫn chạy đến
khi hoàn tất. Có thể bấm tải rồi quay lại menu để thử trường hợp dispose.

## 9. Chia sẻ giữa widget và route

[counter_scope.dart](lib/widgets/counter_scope.dart) kế thừa `InheritedNotifier`:

- `CounterScope.watch(context)`: dùng `dependOnInheritedWidgetOfExactType`,
  đăng ký widget hiện tại cần rebuild khi nguồn thông báo.
- `CounterScope.read(context)`: dùng `getInheritedWidgetOfExactType`, lấy nguồn
  trong callback mà không đăng ký rebuild.

`watch` và `read` ở đây là tên hai hàm tự viết, không phải API của Provider.
Chỉ các widget đăng ký phụ thuộc scope mới được scope đánh dấu cần cập nhật;
chúng vẫn có thể rebuild vì các nguyên nhân Flutter thông thường khác.

Route mới do Navigator tạo không tự nằm dưới scope đặt bên trong route cũ.
Ví dụ 08 bọc route mới bằng một scope khác dùng **cùng notifier**.
Màn hình phụ không dispose nguồn. Với state toàn ứng dụng, có thể đặt scope
phía trên Navigator và để chủ sở hữu sống cùng ứng dụng.

## 10. Kiểm tra

Từ thư mục gốc:

```sh
cd packages/package_state_ValueNotifier
flutter pub get
flutter analyze
```

## Tài liệu Flutter chính thức

- [Mã nguồn Listenable, ChangeNotifier và ValueNotifier](https://github.com/flutter/flutter/blob/stable/packages/flutter/lib/src/foundation/change_notifier.dart)
- [ValueListenableBuilder và child](https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html)
- [ListenableBuilder](https://api.flutter.dev/flutter/widgets/ListenableBuilder-class.html)
- [TextEditingController](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html)
- [InheritedNotifier](https://api.flutter.dev/flutter/widgets/InheritedNotifier-class.html)
