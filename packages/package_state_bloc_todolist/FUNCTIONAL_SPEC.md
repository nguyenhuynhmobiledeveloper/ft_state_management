# Đặc tả chức năng ứng dụng To-Do List

Tài liệu này mô tả **hành vi hiện có** của `package_state_bloc_todolist`, dùng làm chuẩn đối chiếu khi xây dựng lại bằng Riverpod, Provider hoặc cơ chế quản lý state khác. Mục tiêu là giữ nguyên chức năng, dữ liệu lưu trữ và trải nghiệm người dùng; cách tổ chức lớp và API của thư viện quản lý state có thể thay đổi.

## 1. Khởi chạy và màn hình chính

- Ứng dụng khởi chạy trực tiếp vào một màn hình danh sách công việc; không có điều hướng hay màn hình khác.
- `MaterialApp` dùng Material 3, bảng màu tạo từ `Colors.indigo`, tắt banner debug. Tiêu đề ứng dụng là `Todo BLoC`; thanh trên cùng hiển thị `To-Do List với BLoC` trong bản gốc. Nếu cần giao diện giống hệt, giữ nguyên các chuỗi này kể cả khi thay đổi cơ chế quản lý state.
- Khi mở màn hình, ứng dụng tự động đọc danh sách đã lưu. Trong thời gian đọc, phần thân chỉ hiển thị vòng tròn tải ở giữa màn hình; ô nhập và danh sách chưa xuất hiện.
- Sau khi đọc xong, màn hình hiển thị ô nhập, nút thêm, bộ đếm, ba bộ lọc và danh sách hoặc thông báo rỗng.
- State khởi tạo: `todos = []`, `filter = all`, `isLoading = true`, `errorMessage = null`. Bộ lọc không được lưu; mỗi lần tạo ứng dụng mới, bộ lọc bắt đầu ở **Tất cả**.

## 2. Dữ liệu công việc

Mỗi công việc (`Todo`) có ba thuộc tính:

| Thuộc tính | Kiểu | Ý nghĩa |
| --- | --- | --- |
| `id` | `String` | Mã định danh; khi thêm mới lấy từ số microsecond của thời điểm hiện tại rồi chuyển thành chuỗi. |
| `title` | `String` | Nội dung công việc. |
| `isCompleted` | `bool` | Trạng thái hoàn thành; mặc định là `false`. |

Danh sách giữ thứ tự được lưu: công việc mới được **thêm vào cuối**. Không có chức năng sửa nội dung, sắp xếp lại, tìm kiếm, hoàn tác hay xác nhận trước khi xóa.

## 3. Các thao tác của người dùng

### Thêm công việc

- Ô nhập có nhãn `Công việc mới`, gợi ý `Ví dụ: Học Flutter`. Người dùng có thể nhấn nút `Thêm` hoặc phím gửi trên bàn phím.
- Nội dung được `trim()` ở hai nơi: khi gửi từ màn hình và khi xử lý thao tác thêm. Khoảng trắng ở đầu/cuối không được lưu; chuỗi rỗng sau khi cắt khoảng trắng không tạo công việc và không hiện lỗi.
- Với nội dung hợp lệ, màn hình gửi yêu cầu thêm và **xóa ô nhập ngay**, trước khi thao tác lưu hoàn tất. Công việc mới có `isCompleted = false` và nằm cuối danh sách.
- Sau khi lưu thành công, danh sách và bộ đếm cập nhật. Nếu đang chọn **Đã xong**, công việc mới không xuất hiện trong danh sách lọc dù đã được thêm.
- Không kiểm tra trùng nội dung: có thể tạo nhiều công việc cùng `title`.

### Đánh dấu hoàn thành / chưa hoàn thành

- Mỗi dòng có một checkbox. Nhấn checkbox đảo `isCompleted` của công việc tương ứng từ `false` sang `true` hoặc ngược lại.
- Công việc đã hoàn thành có tiêu đề gạch ngang; công việc chưa hoàn thành có chữ bình thường.
- Sau khi lưu thành công, bộ đếm và danh sách theo bộ lọc được tính lại. Vì vậy một dòng có thể biến mất khỏi bộ lọc hiện tại ngay sau khi đổi trạng thái.

### Xóa công việc

- Mỗi dòng có nút biểu tượng `delete_outline`, tooltip `Xóa công việc`.
- Nhấn nút xóa công việc tương ứng ngay sau khi lưu thành công. Không có hộp thoại xác nhận hay nút hoàn tác.
- Thứ tự các công việc còn lại được giữ nguyên.

### Lọc danh sách

Ba `ChoiceChip` chỉ cho phép chọn một bộ lọc tại một thời điểm:

| Nhãn | Giá trị | Công việc hiển thị |
| --- | --- | --- |
| `Tất cả` | `all` | Toàn bộ công việc. |
| `Chưa xong` | `active` | Các công việc có `isCompleted = false`. |
| `Đã xong` | `completed` | Các công việc có `isCompleted = true`. |

Đổi bộ lọc chỉ thay đổi danh sách hiển thị, **không thay đổi hay ghi lại dữ liệu lưu trữ**. Danh sách lọc vẫn giữ thứ tự gốc. Nếu bộ lọc đang chọn không có công việc phù hợp, hiển thị `Chưa có công việc nào.` kể cả khi bộ lọc khác có dữ liệu.

## 4. Bộ đếm và danh sách hiển thị

- Dòng thống kê có dạng `Còn X/Y công việc chưa hoàn thành`.
- `X` là số công việc chưa hoàn thành trong **toàn bộ** danh sách; `Y` là tổng số công việc. Hai số này không phụ thuộc bộ lọc đang chọn.
- Khi danh sách theo bộ lọc không rỗng, hiển thị bằng danh sách cuộn. Mỗi công việc là một `Card` chứa checkbox bên trái, tiêu đề ở giữa và nút xóa bên phải.
- Khi không có công việc phù hợp, hiển thị thông báo rỗng ở giữa vùng danh sách. Bộ đếm, ô nhập và bộ lọc vẫn hiển thị.

## 5. Lưu trữ cục bộ

- Dùng `SharedPreferencesAsync`; khóa lưu trữ là chuỗi `todos`.
- Giá trị lưu là **một chuỗi JSON chứa mảng** công việc theo đúng thứ tự đang có. Mỗi phần tử có các khóa `id`, `title`, `isCompleted`.
- Nếu chưa có dữ liệu ở khóa `todos`, tải về danh sách rỗng. Nếu một phần tử JSON cũ thiếu `isCompleted`, giá trị được hiểu là `false`.
- Thêm, đổi trạng thái hoặc xóa: tạo danh sách mới, ghi **toàn bộ danh sách** vào lưu trữ, rồi mới cập nhật danh sách trên màn hình khi ghi thành công.
- Bộ lọc, trạng thái tải, thông báo lỗi và nội dung đang gõ trong ô nhập không được lưu.
- Để các bản Riverpod/Provider dùng chung dữ liệu với bản BLoC, giữ nguyên khóa `todos` và cấu trúc JSON này.

Ví dụ dữ liệu lưu:

```json
[{"id":"123456789","title":"Học Flutter","isCompleted":false}]
```

## 6. Lỗi và thứ tự xử lý

- Nếu tải dữ liệu thất bại, dừng trạng thái tải và hiển thị snackbar `Không thể tải danh sách công việc.`. Màn hình sau đó hiển thị danh sách đang có trong state; ở lần khởi chạy đầu thường là danh sách rỗng.
- Nếu lưu thay đổi thất bại, hiển thị snackbar `Không thể lưu thay đổi.`. Danh sách trên màn hình không nhận thay đổi vừa thử vì chỉ cập nhật sau khi lưu thành công. Riêng khi thêm, ô nhập đã bị xóa trước đó.
- Lỗi không được hiển thị cố định trên màn hình; snackbar xuất hiện khi có state mới mang thông báo lỗi.
- Các thao tác được xử lý **tuần tự theo thứ tự nhận**. Thao tác sau chờ thao tác trước xong, kể cả khi đang chờ đọc/ghi dữ liệu. Đây là chi tiết quan trọng để tránh mất cập nhật khi thao tác nhanh.
- Sau mỗi lần tạo state mới bằng `copyWith`, `errorMessage` trở về `null` nếu không truyền lỗi mới. Không có cơ chế tự động thử lại; muốn tải lại phải gửi lại yêu cầu tải.

## 7. Chi tiết giao diện để đối chiếu

- Padding nội dung: `16`; khoảng cách giữa ô nhập và nút thêm: `8`.
- Sau hàng nhập: khoảng cách dọc `20`; sau bộ đếm và sau hàng bộ lọc: mỗi khoảng cách `12`.
- Hàng bộ lọc là `Wrap` với khoảng cách ngang `8`. Các dòng danh sách cách nhau `8`.
- Nút thêm dùng icon `add` và nhãn `Thêm`; checkbox hiển thị đúng giá trị hoàn thành của từng công việc.
- Toàn bộ danh sách nằm trong vùng còn lại của màn hình; vòng tròn tải và thông báo rỗng được căn giữa ở vùng tương ứng.

## 8. Danh sách kiểm tra tương đương chức năng

- [ ] Khởi chạy: thấy trạng thái tải, sau đó tải dữ liệu cũ; mặc định chọn **Tất cả**.
- [ ] Lần đầu chưa có dữ liệu: `Còn 0/0 công việc chưa hoàn thành` và `Chưa có công việc nào.`.
- [ ] Thêm bằng nút hoặc phím gửi; bỏ qua nội dung chỉ có khoảng trắng; cắt khoảng trắng đầu/cuối; cho phép trùng tiêu đề.
- [ ] Công việc mới ở cuối, chưa hoàn thành, tồn tại sau khi khởi chạy lại.
- [ ] Đánh dấu và bỏ đánh dấu cập nhật checkbox, gạch ngang, bộ đếm và danh sách lọc; trạng thái tồn tại sau khi khởi chạy lại.
- [ ] Xóa không cần xác nhận, không đổi thứ tự các công việc còn lại; kết quả tồn tại sau khi khởi chạy lại.
- [ ] Ba bộ lọc cho đúng tập công việc; bộ đếm luôn tính toàn bộ danh sách; bộ lọc trở về **Tất cả** khi tạo ứng dụng mới.
- [ ] Khi bộ lọc không có kết quả, hiện thông báo rỗng dù các bộ lọc khác vẫn có công việc.
- [ ] Lỗi tải/lưu hiển thị đúng snackbar; lỗi lưu không cập nhật danh sách; ô nhập vẫn bị xóa khi thử thêm.
- [ ] Các thao tác nhanh được xử lý tuần tự và không làm mất cập nhật.

## Nguồn đối chiếu trong package

- `lib/main.dart`: khởi chạy, theme và yêu cầu tải ban đầu.
- `lib/screens/todo_screen.dart`: giao diện và tương tác.
- `lib/bloc/todo_event.dart`, `lib/bloc/todo_state.dart`, `lib/bloc/todo_bloc.dart`: các thao tác, state, bộ lọc và luồng lỗi.
- `lib/models/todo.dart`, `lib/repositories/todo_repository.dart`: mô hình dữ liệu và lưu trữ.
