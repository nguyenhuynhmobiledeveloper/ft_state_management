import 'package:flutter/foundation.dart';

import '../models/message_state.dart';
import '../repositories/message_repository.dart';

/// Cách 1: chứa ValueNotifier bên trong, chỉ công khai ValueListenable.
class MessageController {
  MessageController({MessageRepository? repository})
    : _repository = repository ?? const MessageRepository();

  // Tạo 1 đối tượng của class repository
  final MessageRepository _repository;

  // Tạo 1 đối tượng ValueNotifier có giá trị từ class name với tên là initial()
  final _state = ValueNotifier<MessageState>(const MessageState.initial());
  // Khai báo getter có thể lắng nghe được
  ValueListenable<MessageState> get state => _state;

  // Các thuộc tính của class
  bool _disposed = false;
  int _requestId = 0;

  // Giả lập 1 hàm load dữ liệu
  Future<void> load({bool shouldFail = false}) async {
    if (_disposed) return;

    final requestId = ++_requestId;
    // Thay đổi giá trị state của ValueNotifier
    _state.value = const MessageState.loading();

    try {
      final message = await _repository.fetch(shouldFail: shouldFail);
      // Bỏ qua nếu đã rời màn hình hoặc một yêu cầu mới hơn đã bắt đầu.
      if (_disposed || requestId != _requestId) return;
      // Cập nhật giá trị
      _state.value = MessageState.success(message);
    } catch (_) {
      if (_disposed || requestId != _requestId) return;
      // Khi call API thất bại - thay đổi giá trị của ValueNotifier
      _state.value = const MessageState.error(
        'Không tải được dữ liệu. Hãy thử lại.',
      );
    }
  }

  // Hàm dispose trong class
  void dispose() {
    _disposed = true;
    _state.dispose();
  }
}
