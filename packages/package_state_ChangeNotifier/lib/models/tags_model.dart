import 'package:flutter/foundation.dart';

class TagsModel extends ChangeNotifier {
  final List<String> _tags = ['Flutter'];

  // Trả bản sao chỉ đọc để UI không thể sửa list mà quên thông báo.
  List<String> get tags => List.unmodifiable(_tags);
  int get count => _tags.length;

  void add(String text) {
    final tag = text.trim();
    if (tag.isEmpty || _tags.contains(tag)) return;

    // Có thể sửa list nội bộ tại chỗ vì model chủ động gọi notifyListeners.
    _tags.add(tag);
    notifyListeners();
  }

  void remove(String tag) {
    if (!_tags.remove(tag)) return;
    notifyListeners();
  }

  void clear() {
    if (_tags.isEmpty) return;
    _tags.clear();
    notifyListeners();
  }
}
