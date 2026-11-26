/// enum: kiểu dữ liệu liệt kê, chỉ nhận một trong các giá trị đã định nghĩa.
/// - initial: chưa bắt đầu tải dữ liệu.
/// - loading: đang tải dữ liệu.
/// - success: tải thành công.
/// - error: tải thất bại.
/// Ví dụ: LoadStatus.loading là một giá trị thuộc kiểu LoadStatus.
enum LoadStatus { initial, loading, success, error }

/// Một snapshot bất biến: UI nhận đủ thông tin trong một lần thông báo.
/// "Snapshot" là bộ dữ liệu mô tả trạng thái tại một thời điểm, gồm cả ba field:
/// status (trạng thái tải), message (nội dung), error (thông báo lỗi).
///
/// Class này dùng các "named constructor" (hàm khởi tạo có tên):
/// MessageState.initial(), .loading(), .success(...) và .error(...).
/// Đây là bốn cách khởi tạo đối tượng cùng kiểu MessageState, không phải bốn class con hay bốn phương thức chuyển đổi trạng thái.
/// Tên constructor giúp người đọc biết ngay đối tượng được tạo để làm gì.
///
/// Ví dụ vòng đời sử dụng trong MessageController:
/// ```dart
/// const initial = MessageState.initial();
/// const loading = MessageState.loading();
/// final success = MessageState.success(messageFromApi);
/// const failure = MessageState.error('Không tải được dữ liệu');
/// ```
/// messageFromApi ở ví dụ trên là biến String nhận được khi chạy chương trình.
/// Mỗi dòng khởi tạo một state; chúng không sửa đối tượng initial trước đó.
/// Controller gán state vào _state.value (ValueNotifier), UI lắng nghe notifier để cập nhật.
/// Bản thân MessageState chỉ chứa dữ liệu, không tự phát thông báo.
class MessageState {
  // `const` trước constructor cho phép tạo đối tượng hằng tại thời điểm biên dịch khi lời gọi nằm trong ngữ cảnh const và mọi đối số đều là hằng.
  // Ví dụ: const MessageState.initial().
  // Các lần tạo hằng cùng constructor, cùng giá trị sẽ dùng chung đối tượng hằng (canonicalization).
  // Constructor const vẫn gọi được khi chạy với dữ liệu không phải hằng,
  // ví dụ MessageState.success(messageFromApi); khi đó không dùng const.
  // Các field của class này đều final nên đáp ứng điều kiện cần cho const.

  // `.initial` là tên constructor; `()` nghĩa là không có tham số.
  // Dấu `:` bắt đầu initializer list (danh sách khởi tạo các field).
  // Các phép gán được ngăn bằng dấu `,` và diễn ra trước thân constructor.
  // Dấu `;` kết thúc constructor này vì không có thân `{ ... }`.
  const MessageState.initial()
    : status = LoadStatus.initial, // Trạng thái ban đầu, chưa tải.
      message = '', // Chưa có nội dung nên dùng chuỗi rỗng.
      error = ''; // Chưa có lỗi nên dùng chuỗi rỗng.

  // Tạo một state đang tải. Cách viết giống constructor initial ở trên.
  // Cả message và error được đặt rỗng, không giữ nội dung/lỗi từ state cũ.
  // Ví dụ: const MessageState.loading().
  const MessageState.loading()
    : status = LoadStatus.loading,
      message = '',
      error = '';

  // `this.message` là initializing formal parameter: tham số đồng thời khởi tạo trực tiếp field message của đối tượng đang được tạo (`this`).
  // Kiểu String của tham số được suy ra từ khai báo field message bên dưới.
  // Đây là tham số vị trí bắt buộc: MessageState.success('Xin chào').
  // Nó không phải tham số có tên dạng {String message}.
  //
  // Cách viết tương đương, dài hơn:
  // const MessageState.success(String value)
  //   : message = value, status = LoadStatus.success, error = '';
  //
  // message đã được khởi tạo bằng this.message, nên sau dấu `:` chỉ cần khởi tạo hai field còn lại: status là thành công, error là chuỗi rỗng.
  const MessageState.success(this.message)
    : status = LoadStatus.success,
      error = '';

  // Tương tự success, nhưng chuỗi truyền vào được gán cho field error.
  // Ví dụ: const MessageState.error('Mất kết nối mạng').
  // State này có status là lỗi và không chứa nội dung message.
  //
  // Tên `error` xuất hiện ở ba nơi nhưng có vai trò khác nhau:
  // - MessageState.error(...): constructor có tên error.
  // - this.error: field String chứa nội dung lỗi của đối tượng.
  // - LoadStatus.error: giá trị error thuộc enum LoadStatus.
  const MessageState.error(this.error)
    : status = LoadStatus.error,
      message = '';

  // `final` là field chỉ được gán một lần khi khởi tạo đối tượng.
  // Sau khi tạo state, không thể viết: state.message = 'Nội dung mới'.
  // Muốn thay đổi trạng thái, tạo MessageState khác rồi gán vào notifier.
  // `final` không có nghĩa là giá trị phải biết trước khi biên dịch:
  // message/error vẫn có thể nhận chuỗi lấy từ API khi chương trình chạy.
  // Với class này, enum và String cũng bất biến nên state là bất biến.

  // Field kiểu LoadStatus, dùng để UI quyết định hiển thị giao diện nào.
  final LoadStatus status;

  // Field kiểu String, chứa nội dung khi thành công; các state khác dùng ''.
  final String message;

  // Field kiểu String, chứa thông báo khi lỗi; các state khác dùng ''.
  final String error;

  // Cả ba field đều không nullable (không có dấu `?`), nên mỗi constructor phải khởi tạo đủ cả ba trước khi đối tượng được sử dụng.
  // Cách tổ chức này gom các giá trị liên quan vào một state, đồng thời giúp  tránh phải lặp lại status/message/error mỗi lần tạo trạng thái quen thuộc.
}
