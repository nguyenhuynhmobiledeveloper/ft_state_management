import 'package:flutter/material.dart';

import '../models/counter_model.dart';

/// Nghe thủ công để tự rebuild UI và chạy side effect có điều kiện.
class CounterListener extends StatefulWidget {
  const CounterListener({super.key, required this.counter});

  final CounterModel counter; // Mượn từ cha, không sở hữu model này.

  @override
  State<CounterListener> createState() => _CounterListenerState();
}

class _CounterListenerState extends State<CounterListener> {
  @override
  void initState() {
    super.initState();
    widget.counter.addListener(_onChanged); // Vào cái là lắng nghe luôn
  }

  @override
  void didUpdateWidget(CounterListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.counter != widget.counter) {
      oldWidget.counter.removeListener(_onChanged);
      widget.counter.addListener(_onChanged);
    }
    // Flutter sẽ build lại sau didUpdateWidget, không cần setState ở đây.
  }

  // Hàm sẽ chạy khi lắng nghe gía trị của ChangeNotifier
  void _onChanged() {
    if (!mounted) return;
    setState(() {}); // Đọc count mới trong build.

    final count = widget.counter.count;
    // Lắng nghe để show snackbar
    if (count > 0 && count % 3 == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã đạt mốc $count!')));
    }
  }

  @override
  void dispose() {
    // Gỡ đúng callback đã đăng ký. Model vẫn thuộc về widget cha.
    widget.counter.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Giá trị nghe thủ công: ${widget.counter.count}');
  }
}
