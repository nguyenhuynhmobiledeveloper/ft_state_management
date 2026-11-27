import 'package:flutter/foundation.dart';

/// Một model có thể quản lý nhiều field liên quan với nhau.
class SettingsModel extends ChangeNotifier {
  bool _isDark = false;
  double _fontSize = 18;

  bool get isDark => _isDark;
  double get fontSize => _fontSize;

  void setDark(bool value) {
    update(isDark: value, fontSize: _fontSize);
  }

  // Thay đổi font thì isDark vẫn giữ nguyên giá trị cũ
  void setFontSize(double value) {
    update(isDark: _isDark, fontSize: value);
  }

  // Cập nhật giá trị state xong thông báo
  void update({required bool isDark, required double fontSize}) {
    final validSize = fontSize.clamp(14.0, 30.0).toDouble();
    if (_isDark == isDark && _fontSize == validSize) return;

    // Cập nhật đủ các field trước, rồi chỉ gửi MỘT thông báo.
    // Listener sẽ đọc được bộ dữ liệu nhất quán.
    _isDark = isDark;
    _fontSize = validSize;
    notifyListeners();
  }

  void reset() => update(isDark: false, fontSize: 18);
}
