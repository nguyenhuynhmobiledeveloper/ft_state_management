// Import các API Flutter dùng trong file: InheritedNotifier, ValueNotifier,
// BuildContext... material.dart cũng export các API nền tảng này.
import 'package:flutter/material.dart';

/// Chia sẻ ValueNotifier bằng Flutter SDK, không cần Provider.
/// Cơ chế được sử dụng là InheritedNotifier: cung cấp notifier cho cây widget con và yêu cầu các widget đã đăng ký phụ thuộc build lại khi notifier thông báo.
///
/// Ví dụ sử dụng (counter được tạo và quản lý bên ngoài CounterScope):
/// ```dart
/// final counter = ValueNotifier<int>(0);
/// CounterScope(counter: counter, child: const MyScreen());
/// ```
/// Trong build của widget nằm dưới CounterScope:
/// ```dart
/// final count = CounterScope.watch(context).value;
/// return Text('$count');
/// ```
/// Trong callback của nút bấm:
/// ```dart
/// onPressed: () => CounterScope.read(context).value++;
/// ```
/// watch và read đều trả về cùng notifier được truyền vào scope gần nhất; chúng không tạo bản sao của bộ đếm.
///  Đây là hai hàm do ứng dụng tự định nghĩa, không phải từ khóa Dart hay phương thức có sẵn của InheritedNotifier.
///
/// CounterScope chỉ mượn notifier để chia sẻ và lắng nghe, không sở hữu nó.
/// Nơi tạo counter chịu trách nhiệm gọi counter.dispose() khi không còn dùng.
/// Ví dụ: State trong example_08_shared_state.dart tạo và dispose _counter.
///
// `class CounterScope`: khai báo một kiểu widget có tên CounterScope.
// `extends`: kế thừa class cha, sử dụng lại cơ chế có sẵn của class cha.

// `InheritedNotifier<T>` là class có tham số kiểu (generic) T phải là Listenable, tức là đối tượng hỗ trợ addListener/removeListener để theo dõi thông báo.
// Ở đây T = ValueNotifier<int>: notifier giữ một số nguyên trong thuộc tính value.
// Hai dấu `>>` đóng hai cặp generic lồng nhau: <ValueNotifier<int>>.
//
// InheritedNotifier kế thừa InheritedWidget, đưa dữ liệu xuống cây widget.
// CounterScope không tự vẽ giao diện hay cần viết build như StatelessWidget; giao diện hiển thị được cung cấp qua child.
class CounterScope extends InheritedNotifier<ValueNotifier<int>> {
  // Constructor không có tên phụ, được gọi bằng CounterScope(...).
  // Dấu `{ ... }` bên trong `()` khai báo các tham số có tên (named parameters):
  // người gọi phải viết counter: ..., child: ..., key: ... thay vì dựa vào vị trí.
  // Thứ tự các tham số có tên khi gọi không quan trọng.
  //
  // `const` cho phép tạo widget hằng khi lời gọi và các đối số đủ điều kiện const.
  // Với counter là ValueNotifier tạo lúc chạy, gọi CounterScope(...) không const.
  // Constructor const không làm counter.value bất biến: giá trị bên trong notifier vẫn thay đổi được. `
  // child: const MyScreen()` cũng không ngăn widget đó build lại nếu nó đã đăng ký phụ thuộc qua watch(context).
  const CounterScope({
    // `super.key`: super parameter, chuyển tham số key vào constructor class cha.
    // key là tùy chọn; Flutter dùng Key để nhận diện widget khi cập nhật cây.
    super.key,

    // `required`: người gọi bắt buộc phải truyền tham số có tên counter.
    // `ValueNotifier<int>`: kiểu của tham số; không có `?` nên không nhận null.
    // `counter` là tham số constructor, không phải field `this.counter`.
    // Đối tượng này được chuyển cho field notifier của class cha ở dòng super.
    required ValueNotifier<int> counter,

    // Bắt buộc truyền child, và chuyển thẳng tham số này cho class cha.
    // Kiểu Widget của child được suy ra từ tham số tương ứng của class cha.
    // Mọi widget con bên dưới child có thể lấy counter qua BuildContext phù hợp.
    required super.child,
  }) : super(notifier: counter);

  // `: super(notifier: counter)` là lời gọi constructor class cha trong initializer list (phần khởi tạo sau dấu `:`).
  // Ở đây:
  // - Bên trái `notifier:` là tên tham số của constructor InheritedNotifier.
  // - Bên phải `counter` là đối số vừa nhận từ người gọi CounterScope.
  // Như vậy, notifier của scope trỏ đến đúng đối tượng counter được truyền vào.
  // Dấu `;` kết thúc constructor vì constructor này không có thân `{ ... }`.
  //
  // Cách viết dài hơn, tương đương với các super parameter ở trên:
  // const CounterScope({
  //   Key? key,
  //   required ValueNotifier<int> counter,
  //   required Widget child,
  // }) : super(key: key, notifier: counter, child: child);

  // Gọi trong build: lấy notifier và đăng ký rebuild khi notifier thông báo.
  // `static`: hàm thuộc class, gọi CounterScope.watch(context), không cần có đối tượng scope sẵn để gọi scope.watch(...); hàm sẽ tìm scope từ context.
  // `ValueNotifier<int>` trước tên hàm là kiểu trả về: trả notifier, không trả int.
  // `(BuildContext context)` là một tham số vị trí bắt buộc có kiểu BuildContext.
  // context đại diện cho vị trí của widget đang gọi trong cây widget.

  static ValueNotifier<int> watch(BuildContext context) {
    // `final scope`: biến cục bộ chỉ được gán một lần; Dart tự suy ra kiểu CounterScope? từ kết quả hàm.
    // Dấu `?` nghĩa là có thể trả về null.
    // `final` không làm notifier bên trong scope trở thành bất biến.
    //
    // dependOnInheritedWidgetOfExactType<CounterScope>():
    // - Tìm ancestor (widget tổ tiên) gần nhất có đúng kiểu CounterScope.
    // - `<CounterScope>` là đối số kiểu generic của phương thức tìm kiếm.
    // - `()` gọi phương thức; không có đối số thông thường.
    // - Đăng ký Element gắn với context này phụ thuộc vào scope tìm được.
    // Khi counter thông báo thay đổi, Flutter lên lịch build lại widget phụ thuộc.
    // Ví dụ: _CounterValue gọi watch trong build thì _CounterValue được cập nhật; việc này không đồng nghĩa mọi widget dưới scope đều phải build lại.
    final scope = context.dependOnInheritedWidgetOfExactType<CounterScope>();

    // assert(điều kiện, thông báo, Khẳng định): kiểm tra giả định trong chế độ debug.
    // Nếu context không nằm dưới CounterScope, scope là null và assert báo lỗi với thông điệp dễ hiểu.
    // Assert bị bỏ qua trong bản release thông thường.
    // Cần dùng context của widget con: context của widget đang tạo CounterScope trong chính build của nó vẫn ở phía trên scope mới, nên không tìm thấy nó.
    assert(scope != null, 'Cần đặt widget bên trong CounterScope.');

    // `return`: trả kết quả cho nơi gọi và kết thúc hàm.
    // `scope!`: toán tử khẳng định khác null, cho phép truy cập thuộc tính.
    // Nếu scope thực sự null, dấu `!` gây lỗi lúc chạy, kể cả ở release.
    // `.notifier`: field kế thừa từ InheritedNotifier, giữ ValueNotifier<int>.
    // `notifier!`: cần dấu `!` thứ hai vì class cha khai báo notifier có thể null.
    // Constructor CounterScope ở trên luôn truyền counter không null vào đó.
    // Dấu `!` không phải tạo giá trị mặc định hay xử lý trường hợp null.
    // Vì trả notifier, muốn lấy số hiện tại thì đọc thêm `.value` ở nơi gọi.
    return scope!.notifier!;
  }

  // Gọi trong callback: lấy notifier để đọc/ghi mà không đăng ký rebuild.
  // Cú pháp static, kiểu trả về và tham số context giống hàm watch phía trên.
  static ValueNotifier<int> read(BuildContext context) {
    // getInheritedWidgetOfExactType cũng tìm CounterScope gần nhất theo context, nhưng không đăng ký context này phụ thuộc vào scope.
    // Vì vậy, chỉ gọi read không khiến widget tự build lại khi counter thay đổi; widget vẫn có thể build lại vì nguyên nhân khác, ví dụ cha build lại.
    // Nếu cần hiển thị giá trị và tự cập nhật theo nó, dùng watch trong build.
    final scope = context.getInheritedWidgetOfExactType<CounterScope>();

    // Kiểm tra đã đặt CounterScope phía trên, giống hàm watch.
    assert(scope != null, 'Cần đặt widget bên trong CounterScope.');

    // Vẫn trả chính notifier được chia sẻ, không phải bản sao hay chỉ số int.
    // Ví dụ: CounterScope.read(context).value++ tương đương với:
    // final counter = CounterScope.read(context);
    // counter.value = counter.value + 1;
    // ValueNotifier thông báo khi giá trị được gán mới khác giá trị cũ theo ==.
    // Các widget đã watch cùng scope sẽ được cập nhật nhờ InheritedNotifier.
    // Widget chỉ read không đăng ký phụ thuộc qua lời gọi read đó.
    return scope!.notifier!;
  }
}

// Luồng hoạt động trong example_08_shared_state.dart:
// 1. State tạo _counter = ValueNotifier<int>(0).
// 2. CounterScope(counter: _counter, child: ...) chia sẻ _counter cho cây con.
// 3. _CounterValue gọi watch(context).value để hiển thị và đăng ký phụ thuộc.
// 4. _IncrementButton gọi read(context).value++ trong onPressed để tăng số.
// 5. Notifier thông báo -> InheritedNotifier yêu cầu widget phụ thuộc build lại  -> _CounterValue đọc giá trị mới và cập nhật Text, không cần tự setState.
//
// Khi có nhiều CounterScope lồng nhau, mỗi context lấy scope gần nhất phía trên.
// Scope chỉ có hiệu lực với các widget con, không tự trở thành dữ liệu toàn app.
// Trong ví dụ, route thứ hai được bọc bằng CounterScope và truyền cùng counter,  vì route mới không nằm dưới scope đặt bên trong route thứ nhất.
// Hai scope dùng cùng notifier nên thao tác ở một màn hình cập nhật cùng bộ đếm.
// InheritedNotifier tự quản lý việc thêm/gỡ listener khi được gắn/cập nhật/gỡ khỏi cây; nó không gọi dispose() cho notifier do bên ngoài truyền vào.
