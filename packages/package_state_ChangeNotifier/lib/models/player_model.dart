import 'package:flutter/foundation.dart';

/// Giả sử đã có class cha cho thiết bị âm thanh.
class AudioDevice {
  const AudioDevice(this.name);

  final String name;
}

/// Dart chỉ có một class cha; dùng mixin để thêm khả năng phát thông báo.
class PlayerModel extends AudioDevice with ChangeNotifier {
  PlayerModel() : super('Loa học Flutter');

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  void toggle() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }
}
