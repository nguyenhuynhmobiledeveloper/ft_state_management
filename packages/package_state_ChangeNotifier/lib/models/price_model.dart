import 'package:flutter/foundation.dart';

class PriceModel extends ChangeNotifier {
  double _price = 20;
  double get price => _price;

  void setPrice(double value) {
    final validPrice = value.clamp(10.0, 100.0).toDouble();
    if (_price == validPrice) return;
    _price = validPrice;
    notifyListeners();
  }
}
