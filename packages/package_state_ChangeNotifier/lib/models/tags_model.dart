import 'package:flutter/foundation.dart';

// Đối tượng thẻ trong danh sách
class TagsModel extends ChangeNotifier {
  final List<String> _tags = ['Flutter'];

  // Trả bản sao chỉ đọc để UI không thể sửa list mà quên thông báo.
  List<String> get tags => List.unmodifiable(_tags);
  int get count => _tags.length;

  // Thêm thẻ vào danh sách
  void add(String text) {
    final tag = text.trim();
    if (tag.isEmpty || _tags.contains(tag)) return;

    // Có thể sửa list nội bộ tại chỗ vì model chủ động gọi notifyListeners.
    _tags.add(tag);
    notifyListeners();
  }

  // Xoá thẻ khỏi danh sách
  void remove(String tag) {
    if (!_tags.remove(tag)) return;
    notifyListeners();
  }

  // Xoá toàn bộ danh sách thẻ
  void clear() {
    if (_tags.isEmpty) return;
    _tags.clear();
    notifyListeners();
  }
}
