import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget mượn nguồn từ cha: chỉ đăng ký / gỡ listener, không dispose nguồn.
class CounterNotice extends StatefulWidget {
  const CounterNotice({super.key, required this.counter, required this.child});

  // Chỉ cần quyền đọc và lắng nghe, không cần quyền gán value.
  // Thuộc tính nhận giá trị ValueNotifier
  // final ValueListenable<int> counter;
  final ValueNotifier<int> counter;
  final Widget child;

  @override
  State<CounterNotice> createState() => _CounterNoticeState();
}

class _CounterNoticeState extends State<CounterNotice> {
  @override
  void initState() {
    super.initState();
    widget.counter.addListener(_showMilestone);
  }

  @override
  void didUpdateWidget(CounterNotice oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cha có thể truyền một nguồn mới vào cùng widget đang tồn tại.
    if (oldWidget.counter != widget.counter) {
      oldWidget.counter.removeListener(_showMilestone);
      widget.counter.addListener(_showMilestone);
    }
  }

  // Hàm hiển thị cột mốc
  void _showMilestone() {
    final count = widget.counter.value;
    if (!mounted || count <= 0 || count % 3 != 0) return;

    // Side effect nằm trong listener, không đặt trong builder dựng UI.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã đạt mốc $count!')));
  }

  @override
  void dispose() {
    widget.counter.removeListener(_showMilestone);
    super.dispose();
  }

  // Vẽ lại tham số child được truyền vào widget
  @override
  Widget build(BuildContext context) => widget.child;
}
