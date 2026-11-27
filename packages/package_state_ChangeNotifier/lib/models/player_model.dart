import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Giả sử đã có class cha cho thiết bị âm thanh.
class AudioDevice {
  const AudioDevice(this.name);

  final String name;
}

/// Dart chỉ có một class cha; dùng mixin để thêm khả năng phát thông báo.
class PlayerModel extends AudioDevice with ChangeNotifier {
  // Constructor của class : có tham số là AudioPlayer
  PlayerModel({AudioPlayer? audioPlayer})
    : _audioPlayer = audioPlayer ?? AudioPlayer(),
      super('Loa học Flutter') {
    _audioPlayer.audioCache = AudioCache();
    _stateSubscription = _audioPlayer.onPlayerStateChanged.listen(
      _onPlayerStateChanged,
      onError: _onPlayerError,
    );
    _eventSubscription = _audioPlayer.eventStream.listen(
      (_) {},
      onError: _onPlayerError,
    );
  }

  static const _assetPath = 'audio/de_danh_cho_em.mp3';
  final AudioPlayer _audioPlayer;
  late final StreamSubscription<PlayerState> _stateSubscription;
  late final StreamSubscription<AudioEvent> _eventSubscription;
  bool _disposed = false;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  String? _error;
  String? get error => _error;

  Future<void> toggle() async {
    if (_disposed || _isBusy) return;

    _isBusy = true;
    _error = null;
    notifyListeners();

    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
      } else {
        // Flutter đặt prefix khác nhau khi chạy package độc lập và từ app gốc.
        final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
        if (_disposed) return;

        const packagePrefix = 'packages/package_state_change_notifier/assets/';
        _audioPlayer.audioCache.prefix =
            manifest.listAssets().contains('$packagePrefix$_assetPath')
            ? packagePrefix
            : 'assets/';
        await _audioPlayer.play(AssetSource(_assetPath));
      }
    } catch (error) {
      _onPlayerError(error);
    } finally {
      if (!_disposed) {
        _isBusy = false;
        notifyListeners();
      }
    }
  }

  void _onPlayerStateChanged(PlayerState state) {
    if (_disposed) return;

    final isPlaying = state == PlayerState.playing;
    if (_isPlaying == isPlaying) return;

    _isPlaying = isPlaying;
    notifyListeners();
  }

  void _onPlayerError(Object error) {
    if (_disposed) return;

    _isPlaying = false;
    _error = 'Không thể phát âm thanh. Vui lòng thử lại.';
    debugPrint('Lỗi phát âm thanh: $error');
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_stateSubscription.cancel());
    unawaited(_eventSubscription.cancel());
    // dispose dừng âm thanh và giải phóng player khi rời màn hình.
    unawaited(_audioPlayer.dispose());
    super.dispose();
  }
}
