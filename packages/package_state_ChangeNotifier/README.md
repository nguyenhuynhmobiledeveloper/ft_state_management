# Học ChangeNotifier bằng Flutter SDK

10 ví dụ nhỏ, có chú thích tiếng Việt và menu để bấm thử. Mỗi màn hình tập trung
vào một tình huống, không có To-do List. Các ví dụ dùng Flutter SDK và
Dart SDK; riêng ví dụ 10 dùng thêm `audioplayers` để phát file MP3.
`flutter_test` và `flutter_lints` chỉ dùng khi phát triển.

Tên thư mục giữ đúng yêu cầu: `package_state_ChangeNotifier`.
Tên package trong Dart là `package_state_change_notifier` theo quy tắc
`lowercase_with_underscores`.

## Chạy ví dụ

Từ **thư mục gốc BUFF_V2**:

```sh
flutter pub get
flutter run -t lib/main_change_notifier.dart
```

Ứng dụng mở menu 10 ví dụ. Entry point riêng sử dụng các thư mục nền tảng của
project gốc; package không chứa project Android/iOS/web riêng.

Để dùng trong ứng dụng Flutter khác:

```yaml
dependencies:
  package_state_change_notifier:
    path: ../BUFF_V2/packages/package_state_ChangeNotifier
```

```dart
import 'package:package_state_change_notifier/package_state_change_notifier.dart';

void main() => runPackageStateChangeNotifierApp();
```

## 1. Đọc theo thứ tự nào?

Đọc **model trước, màn hình sau** để thấy rõ nơi giữ dữ liệu và nơi lắng nghe.

| Ví dụ | Model / nguồn | Màn hình | Thử và quan sát |
| --- | --- | --- | --- |
| 01. Counter | [counter_model.dart](lib/models/counter_model.dart) | [example_01_counter.dart](lib/examples/example_01_counter.dart) | Tăng, giảm, đặt lại; `ListenableBuilder`, `child` và `AnimatedBuilder` |
| 02. Nhiều thuộc tính | [settings_model.dart](lib/models/settings_model.dart) | [example_02_settings.dart](lib/examples/example_02_settings.dart) | Đổi nền, cỡ chữ; cập nhật hai field rồi chỉ thông báo một lần |
| 03. Danh sách thẻ | [tags_model.dart](lib/models/tags_model.dart) | [example_03_tags.dart](lib/examples/example_03_tags.dart) | Thêm, xóa thẻ; list nội bộ có thể sửa nhưng UI chỉ nhận bản sao chỉ đọc |
| 04. Listener thủ công | `CounterModel`, [counter_listener.dart](lib/widgets/counter_listener.dart) | [example_04_manual_listener.dart](lib/examples/example_04_manual_listener.dart) | Tăng đến mốc 3, chuyển bộ đếm A/B; đăng ký, đổi nguồn, gỡ listener |
| 05. Nhiều notifier | [quantity_model.dart](lib/models/quantity_model.dart), [price_model.dart](lib/models/price_model.dart) | [example_05_multiple_notifiers.dart](lib/examples/example_05_multiple_notifiers.dart) | Đổi số lượng và giá; tổng được tính lại khi một trong hai nguồn thay đổi |
| 06. Chia sẻ state | `CounterModel`, [counter_scope.dart](lib/widgets/counter_scope.dart) | [example_06_shared_state.dart](lib/examples/example_06_shared_state.dart) | Tăng ở hai màn hình; cùng một model được truyền qua `InheritedNotifier` |
| 07. Bất đồng bộ | [message_model.dart](lib/models/message_model.dart), [message_repository.dart](lib/repositories/message_repository.dart) | [example_07_async.dart](lib/examples/example_07_async.dart) | Loading, lỗi, thử lại; bấm liên tiếp hoặc rời màn hình khi đang tải |
| 08. FocusNode | `FocusNode` có sẵn trong SDK | [example_08_focus_node.dart](lib/examples/example_08_focus_node.dart) | Chạm ô nhập và bỏ focus; cập nhật dòng thông báo và viền |
| 09. ScrollController | `ScrollController` có sẵn trong SDK | [example_09_scroll_controller.dart](lib/examples/example_09_scroll_controller.dart) | Cuộn danh sách, theo dõi offset, quay về đầu |
| 10. Mixin | [player_model.dart](lib/models/player_model.dart) | [example_10_mixin.dart](lib/examples/example_10_mixin.dart) | Phát / dừng bài Để dành cho em; dùng `with ChangeNotifier` khi đã có class cha |

Mỗi ví dụ tự sở hữu và giải phóng model. Rời ví dụ về menu rồi mở lại sẽ khởi
tạo lại state. Riêng hai màn hình bên trong ví dụ 06 dùng chung model cho đến
khi thoát cả ví dụ. Không lưu state xuống ổ đĩa và không gọi mạng. Ví dụ 10
phát file MP3 đóng gói trong package; rời màn hình sẽ dừng phát.

## 2. Các class và khái niệm liên quan

| Thành phần | Vai trò |
| --- | --- |
| `Listenable` | Interface có `addListener` và `removeListener`, không quy định cách giữ dữ liệu |
| `ChangeNotifier` | Cài đặt danh sách listener và cơ chế phát thông báo; có thể kế thừa hoặc dùng như mixin |
| `VoidCallback` | Callback dạng `void Function()`, không nhận dữ liệu đi kèm thông báo |
| `ListenableBuilder` | Nghe một `Listenable`, tự đăng ký / gỡ callback và dựng lại vùng UI trong builder |
| `AnimatedBuilder` | Cũng nghe `Listenable`; thường dùng với animation, nhưng nhận được cả `ChangeNotifier` |
| `Listenable.merge(...)` | Factory gộp thông báo từ nhiều nguồn, không tạo state hay giá trị tổng mới |
| `InheritedNotifier<T>` | Một `InheritedWidget` chuyên cấp `Listenable` cho cây con và cập nhật widget phụ thuộc |
| `StatefulWidget` / `State` | Giữ model qua các lần build và quản lý vòng đời |
| `FocusNode` | Dùng cơ chế `ChangeNotifier` qua mixin; có thể nghe thay đổi focus |
| `ScrollController` | Kế thừa `ChangeNotifier`; có thể nghe thay đổi vị trí cuộn |
| `ValueNotifier<T>` | Kế thừa `ChangeNotifier`, thêm `.value` và kiểm tra `==` trong setter |
| `TextEditingController` | Kế thừa `ValueNotifier<TextEditingValue>`, do đó cũng thuộc hệ `ChangeNotifier` |

`ChangeNotifier` implements `Listenable`. Nó không có `.value`, không quy định
class state, không tự theo dõi field và không tự dựng UI. Model cung cấp getter
để đọc dữ liệu, phương thức để đổi dữ liệu, rồi gọi `notifyListeners()`.

## 3. Luồng hoạt động cơ bản

```dart
class CounterModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}
```

1. Widget tạo `CounterModel` một lần bằng field của `State`.
2. `ListenableBuilder` đăng ký nghe model.
3. Người dùng bấm nút gọi `increment()`.
4. Model đổi `_count`, sau đó gọi `notifyListeners()`.
5. Builder được đánh dấu cần dựng lại và đọc `model.count` hiện tại.
6. Khi widget sở hữu bị hủy, nó gọi `model.dispose()`.

Không cần dùng `setState` ở màn hình chỉ để cập nhật một `ListenableBuilder`:
builder đã tự nghe nguồn. Ví dụ 04 dùng `setState` riêng để minh họa cách nghe
thủ công, và để đổi lựa chọn bộ đếm cục bộ của widget cha.

## 4. Những API cần hiểu

| API | Ý nghĩa / lưu ý |
| --- | --- |
| `addListener(callback)` | Đăng ký callback; không tự gọi ngay và không truyền state vào callback |
| `removeListener(callback)` | Gỡ đúng callback đã đăng ký |
| `notifyListeners()` | Gọi các listener hiện tại; dùng bên trong model sau khi đổi dữ liệu |
| `dispose()` | Giải phóng danh sách listener; không tự thông báo, không tự hủy Future |
| `hasListeners` | Getter protected cho lớp con; không dùng làm state UI hoặc điều kiện bỏ qua việc cập nhật dữ liệu |
| `ChangeNotifier.debugAssertNotDisposed(model)` | Kiểm tra hỗ trợ debug, thường dùng bên trong `assert`; không thay cho xử lý Future sau dispose |

`notifyListeners()` là API protected: UI nên gọi `increment()`, `update()` hoặc
`load()`, để model quyết định khi nào thông báo. Không gọi nó từ builder chỉ
để ép giao diện cập nhật.

Listener chạy **đồng bộ** trong lúc `notifyListeners()` được thực thi. Đổi dữ
liệu trước khi thông báo để callback đọc được dữ liệu mới. UI được Flutter
build theo lịch khung hình; nhiều thông báo trong cùng khung hình có thể chỉ
dẫn đến một lần build. Không dùng số lần build làm bộ đếm thông báo.

`ChangeNotifier` không tự so sánh dữ liệu. Gọi `notifyListeners()` hai lần dù
không đổi field vẫn phát hai lần. Trong `reset()` và `SettingsModel.update()`,
model tự kiểm tra để tránh thông báo khi dữ liệu giữ nguyên.

## 5. Khác biệt với ValueNotifier

| | `ValueNotifier<T>` | `ChangeNotifier` |
| --- | --- | --- |
| Dữ liệu | Có sẵn `.value` | Tự định nghĩa field, getter, phương thức |
| Phát thông báo | Setter tự phát khi giá trị mới khác giá trị cũ theo `==` | Tự gọi `notifyListeners()` |
| Nhiều field liên quan | Thường gom vào object state bất biến | Có thể giữ nhiều field private trong cùng model |
| Sửa list tại chỗ | Không tự phát hiện thay đổi phần tử | Có thể sửa list nội bộ, rồi chủ động thông báo |
| Builder thường dùng | `ValueListenableBuilder<T>` nhận giá trị trong callback | `ListenableBuilder` tự đọc getter của model |

Ví dụ 03 cố ý sửa `_tags` tại chỗ rồi gọi `notifyListeners()`. Getter `tags`
trả `List.unmodifiable(_tags)`, vừa ngăn UI sửa trực tiếp vừa giữ snapshot cũ
không đổi. Với list object, còn cần bảo vệ dữ liệu bên trong từng phần tử;
bọc list chỉ ngăn sửa cấu trúc list.

## 6. Nhiều field, nhiều nguồn và phạm vi rebuild

**Một model, nhiều field:** cập nhật đủ các field trước rồi thông báo một lần,
như `SettingsModel.update()`. Listener không nhìn thấy trạng thái trung gian
giữa việc đổi nền và đổi cỡ chữ.

Mọi listener của model đều nhận thông báo, không biết field nào vừa đổi.
`ListenableBuilder` không tự chọn field như selector. Nếu các vùng có tốc độ
cập nhật khác nhau, có thể tách model; ví dụ 05 minh họa hai nguồn độc lập.

**Nhiều nguồn:** `Listenable.merge([quantity, price])` phát khi bất kỳ nguồn
nào phát. Iterable đầu vào không được thêm / xóa phần tử sau khi merge.
Nguồn gộp không có `.value`, không sở hữu hay dispose các nguồn đầu vào.

Tổng giá được tính từ `quantity * price` trong builder, không cần giữ một bản
tổng riêng dễ bị lệch dữ liệu. Merge cũng không tự gộp hai thao tác riêng
thành một giao dịch cập nhật dữ liệu.

**Vùng UI cố định:** tham số `child` giúp builder dùng lại subtree không phụ
thuộc dữ liệu đang nghe. Ví dụ 01 giữ nhãn cố định, ví dụ 08 giữ `TextField`.
Subtree này vẫn có thể rebuild khi dependency riêng của nó thay đổi.

**Builder hay listener?** Dùng builder để dựng UI. Dùng listener thủ công cho
side effect như SnackBar hoặc khi cần tự điều khiển việc cập nhật widget.
Đừng đặt SnackBar trong builder vì widget có thể build lại do cha hoặc theme
thay đổi, ngay cả khi model không vừa phát một thông báo mới.

## 7. Vòng đời listener

Xem [counter_listener.dart](lib/widgets/counter_listener.dart):

- `initState`: đăng ký `_onChanged` vào model nhận từ cha.
- `didUpdateWidget`: nếu cha truyền model mới, gỡ callback khỏi model cũ rồi
  đăng ký vào model mới. Flutter sẽ build lại sau đó.
- `_onChanged`: gọi `setState` để cập nhật text, hiện SnackBar ở mốc cần thiết.
- `dispose`: gỡ callback, không dispose model mượn từ cha.

Model do ai tạo thì bên đó chịu trách nhiệm dispose. `ListenableBuilder` và
`InheritedNotifier` quản lý việc nghe nguồn, không tự dispose model truyền vào.
Nếu override `dispose`, luôn gọi `super.dispose()` sau khi dọn tài nguyên riêng.

Không tạo model trong `build`, không đăng ký listener lặp lại trong `build`.
Đăng ký và gỡ cùng một callback; hai anonymous closure viết giống nhau vẫn
là hai đối tượng hàm khác nhau. Đăng ký cùng callback hai lần thì cần gỡ hai lần.

Không tiếp tục dùng model sau dispose, không dispose nó ngay bên trong lượt
`notifyListeners()` đang chạy. Tránh listener tự gọi phương thức làm model
thông báo liên tục dẫn đến vòng lặp. Lỗi do một listener ném ra được Flutter
báo qua `FlutterError.reportError`; thông báo không phải giao dịch có rollback.

## 8. Chia sẻ model bằng InheritedNotifier

[counter_scope.dart](lib/widgets/counter_scope.dart) có hai hàm tự viết:

- `watch(context)` gọi `dependOnInheritedWidgetOfExactType`: dùng trong `build`
  để đăng ký cập nhật widget khi model thông báo.
- `read(context)` gọi `getInheritedWidgetOfExactType`: dùng trong callback để
  lấy model mà không đăng ký rebuild.

Hai tên `watch` / `read` là cách đặt tên của ví dụ, không dùng Provider.
Không gọi `watch` trong `initState`; dùng `build` hoặc `didChangeDependencies`
khi cần thiết lập dependency vào inherited widget.

Route mới không tự nằm dưới scope đặt bên trong route trước. Ví dụ 06 bọc route
mới bằng scope khác dùng cùng instance model. Model sống ở màn hình sở hữu;
màn hình thứ hai chỉ mượn nó. Với phạm vi toàn ứng dụng, có thể đặt scope phía
trên Navigator và để chủ sở hữu sống cùng phạm vi đó.

## 9. Future, lỗi và kết quả trả về muộn

`MessageModel` có `initial`, `loading`, `success`, `error`. Mỗi lần chuyển trạng
thái, model cập nhật đủ các field liên quan trước khi thông báo.

`ChangeNotifier` không tự chạy Future, bắt lỗi hay hủy tác vụ:

- `try/catch` chuyển lỗi giả lập thành dữ liệu cho UI.
- `_requestId` đảm bảo chỉ yêu cầu mới nhất được ghi kết quả. Nếu A bắt đầu
  trước B nhưng kết thúc sau B, kết quả A bị bỏ qua, kể cả khi A thất bại.
- `_disposed` chặn thông báo sau khi model đã được giải phóng.

Các cờ chỉ bỏ qua kết quả; Future giả lập vẫn chạy cho đến khi hoàn tất.
`mounted` bảo vệ việc dùng widget/context, còn `_disposed` bảo vệ model sau
`await`; đây là hai vòng đời khác nhau.

## 10. Controller có sẵn và mixin

**FocusNode:** có sẵn khả năng phát thông báo. Ví dụ 08 nghe trực tiếp nó bằng
`ListenableBuilder`, không cần thêm một model giữ bản sao `hasFocus`.
`TextField` quản lý việc gắn node vào cây focus; màn hình tạo node và dispose nó.

**ScrollController:** ví dụ 09 chỉ rebuild dòng offset khi cuộn, để `ListView`
ở ngoài builder. Kiểm tra `hasClients` trước khi đọc offset và dùng controller
cho một danh sách trong ví dụ này. Việc gắn / gỡ `ScrollPosition` hoặc đổi kích
thước viewport không đồng nghĩa có thông báo cuộn; các nhu cầu đó có API riêng
như `onAttach`, `onDetach` và `ScrollMetricsNotification`.

**Mixin:** khi model đã `extends AudioDevice`, dùng `with ChangeNotifier` để
thêm cơ chế listener. UI vẫn nghe bằng `ListenableBuilder` như cách kế thừa
trực tiếp. `PlayerModel` dùng `audioplayers` phát asset
`assets/audio/de_danh_cho_em.mp3`, là bản sao của file `de_danh _cho_em.mp3`.
Bấm **Phát** để nghe, **Dừng** để dừng và đưa bài về đầu. Model nghe trạng
thái player để cập nhật UI cả khi bài hát kết thúc, chặn thao tác liên tiếp
khi đang xử lý, báo lỗi nếu không phát được và dispose player khi rời màn hình.

Sau khi thêm plugin, dừng ứng dụng rồi chạy lại hoàn toàn để nạp phần native;
hot reload không đủ. Xem [hướng dẫn audioplayers](https://github.com/bluefireteam/audioplayers/blob/main/getting_started.md).

## Cấu trúc

```text
lib/
├── examples/       # 10 màn hình nhỏ, đặt số thứ tự để dễ đọc
├── models/         # Dữ liệu và phương thức thay đổi dữ liệu
├── repositories/   # Giả lập API cho ví dụ bất đồng bộ
├── screens/        # Menu chọn ví dụ
├── widgets/        # Listener thủ công và InheritedNotifier
├── main.dart
└── package_state_change_notifier.dart
test/
├── models_test.dart
└── examples_widget_test.dart
```

## Kiểm tra

```sh
cd packages/package_state_ChangeNotifier
flutter pub get
flutter analyze
flutter test
```

Test kiểm tra dữ liệu nhất quán khi thông báo, tránh thông báo thừa, bảo vệ
list nội bộ, đổi nguồn listener, Future kết thúc sai thứ tự và sau dispose.
Widget test mở cả 10 màn hình ở kích thước điện thoại và thử các tương tác chính.

## Tài liệu Flutter chính thức

- [ChangeNotifier và mã nguồn Listenable](https://github.com/flutter/flutter/blob/stable/packages/flutter/lib/src/foundation/change_notifier.dart)
- [ListenableBuilder](https://api.flutter.dev/flutter/widgets/ListenableBuilder-class.html)
- [AnimatedBuilder](https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html)
- [InheritedNotifier](https://api.flutter.dev/flutter/widgets/InheritedNotifier-class.html)
- [FocusNode](https://api.flutter.dev/flutter/widgets/FocusNode-class.html)
- [ScrollController](https://api.flutter.dev/flutter/widgets/ScrollController-class.html)
