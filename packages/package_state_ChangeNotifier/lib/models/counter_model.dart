import 'package:flutter/foundation.dart';

/// ChangeNotifier chỉ lo thông báo. Dữ liệu và các thao tác do mình định nghĩa.
/// class CounterModel được extends ChangeNotifier : có thể phát thông báo tới giao diện lắng nghe
class CounterModel extends ChangeNotifier {
  int _count = 0;
  int _age = 10;
  int get count => _count; // UI được đọc, không tự gán count.
  int get age => _age;

  // Method tăng trong class
  void increment() {
    _count++;
    notifyListeners(); // Sửa field không tự thông báo như setter của ValueNotifier.
  }

  // method giảm trong class
  void decrement() {
    _count--;
    notifyListeners();
  }

  // method reset trong class
  void reset() {
    // ChangeNotifier không tự kiểm tra ==; mình quyết định bỏ qua khi không đổi.
    if (_count == 0) return;
    _count = 0;
    notifyListeners();
  }

  // Method tăng age trong class
  void incrementAge() {
    _age++;
    notifyListeners(); // Sửa field không tự thông báo như setter của ValueNotifier.
  }
}
