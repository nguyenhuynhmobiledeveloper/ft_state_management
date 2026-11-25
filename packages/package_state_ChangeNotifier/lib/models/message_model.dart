import 'package:flutter/foundation.dart';

import '../repositories/message_repository.dart';

enum LoadStatus { initial, loading, success, error }

class MessageModel extends ChangeNotifier {
  MessageModel({MessageRepository? repository})
    : _repository = repository ?? const MessageRepository();

  final MessageRepository _repository;
  LoadStatus _status = LoadStatus.initial;
  String _message = '';
  String _errorMessage = '';
  int _requestId = 0;
  bool _disposed = false;

  LoadStatus get status => _status;
  String get message => _message;
  String get errorMessage => _errorMessage;

  Future<void> load({bool shouldFail = false}) async {
    if (_disposed) return;
    final requestId = ++_requestId;

    _status = LoadStatus.loading;
    _message = '';
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _repository.fetch(shouldFail: shouldFail);
      // Không ghi state khi đã dispose hoặc một yêu cầu mới hơn đã bắt đầu.
      if (_disposed || requestId != _requestId) return;
      _message = result;
      _status = LoadStatus.success;
    } catch (_) {
      if (_disposed || requestId != _requestId) return;
      _errorMessage = 'Không tải được dữ liệu. Hãy thử lại.';
      _status = LoadStatus.error;
    }

    // Cập nhật đủ dữ liệu của success / error rồi mới thông báo.
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true; // Future vẫn chạy, nhưng kết quả sẽ được bỏ qua.
    super.dispose(); // Giải phóng danh sách listener do ChangeNotifier quản lý.
  }
}
