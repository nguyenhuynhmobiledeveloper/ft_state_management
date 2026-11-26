/// Giả lập API bằng Dart SDK: không mạng, không package bên ngoài.
class MessageRepository {
  // constructor của class
  const MessageRepository();

  // method call api của class
  Future<String> fetch({bool shouldFail = false}) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (shouldFail) throw Exception('Lỗi giả lập');
    return 'Tải dữ liệu thành công bằng Future + ValueNotifier!';
  }
}
