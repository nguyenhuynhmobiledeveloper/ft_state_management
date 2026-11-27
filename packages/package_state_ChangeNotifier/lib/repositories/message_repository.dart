/// Giả lập API bằng Dart SDK, không cần mạng hay package bên ngoài.
class MessageRepository {
  const MessageRepository();
  // Giá lập call API
  Future<String> fetch({bool shouldFail = false}) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (shouldFail) throw Exception('Lỗi giả lập');
    return 'Tải dữ liệu thành công với ChangeNotifier!';
  }
}
