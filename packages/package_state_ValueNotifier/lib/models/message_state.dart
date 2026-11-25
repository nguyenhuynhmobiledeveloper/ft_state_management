enum LoadStatus { initial, loading, success, error }

/// Một snapshot bất biến: UI nhận đủ thông tin trong một lần thông báo.
class MessageState {
  const MessageState.initial()
    : status = LoadStatus.initial,
      message = '',
      error = '';

  const MessageState.loading()
    : status = LoadStatus.loading,
      message = '',
      error = '';

  const MessageState.success(this.message)
    : status = LoadStatus.success,
      error = '';

  const MessageState.error(this.error)
    : status = LoadStatus.error,
      message = '';

  final LoadStatus status;
  final String message;
  final String error;
}
