import 'package:flutter/foundation.dart';

class QuantityModel extends ChangeNotifier {
  int _quantity = 1;
  int get quantity => _quantity;

  void increase() {
    _quantity++;
    notifyListeners();
  }

  void decrease() {
    if (_quantity == 1) return;
    _quantity--;
    notifyListeners();
  }
}
