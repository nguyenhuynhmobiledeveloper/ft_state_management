import 'package:flutter/foundation.dart';

import '../models/message_state.dart';
import '../repositories/message_repository.dart';

/// Cách 1: chứa ValueNotifier bên trong, chỉ công khai ValueListenable.
class MessageController {
  MessageController({MessageRepository? repository})
    : _repository = repository ?? const MessageRepository();

  final MessageRepository _repository;
  final _state = ValueNotifier<MessageState>(const MessageState.initial());
  ValueListenable<MessageState> get state => _state;

  bool _disposed = false;
  int _requestId = 0;

  Future<void> load({bool shouldFail = false}) async {
    if (_disposed) return;

    final requestId = ++_requestId;
    _state.value = const MessageState.loading();

    try {
      final message = await _repository.fetch(shouldFail: shouldFail);
      // Bỏ qua nếu đã rời màn hình hoặc một yêu cầu mới hơn đã bắt đầu.
      if (_disposed || requestId != _requestId) return;
      _state.value = MessageState.success(message);
    } catch (_) {
      if (_disposed || requestId != _requestId) return;
      _state.value = const MessageState.error(
        'Không tải được dữ liệu. Hãy thử lại.',
      );
    }
  }

  void dispose() {
    _disposed = true;
    _state.dispose();
  }
}
