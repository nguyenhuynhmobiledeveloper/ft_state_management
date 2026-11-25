import 'package:flutter/foundation.dart';

/// ChangeNotifier chỉ lo thông báo. Dữ liệu và các thao tác do mình định nghĩa.
class CounterModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count; // UI được đọc, không tự gán count.

  void increment() {
    _count++;
    notifyListeners(); // Sửa field không tự thông báo như setter của ValueNotifier.
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void reset() {
    // ChangeNotifier không tự kiểm tra ==; mình quyết định bỏ qua khi không đổi.
    if (_count == 0) return;
    _count = 0;
    notifyListeners();
  }
}
