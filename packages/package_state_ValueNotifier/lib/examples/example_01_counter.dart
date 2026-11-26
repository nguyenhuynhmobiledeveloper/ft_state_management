import 'package:flutter/material.dart';

class CounterExample extends StatefulWidget {
  const CounterExample({super.key});

  @override
  State<CounterExample> createState() => _CounterExampleState();
}

class _CounterExampleState extends State<CounterExample> {
  // Tạo một lần trong State, KHÔNG tạo lại trong build().
  // state của widget này có dạng là 1 ValueNotifier
  final _count = ValueNotifier<int>(0);

  @override
  void dispose() {
    // Ai tạo notifier thì người đó chịu trách nhiệm dispose.
    _count.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('01. Counter')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ValueListenableBuilder : builder thay đổi khi lắng nghe giá trị thay đổi từ ValueNotifier
            ValueListenableBuilder<int>(
              valueListenable: _count,
              // Phần cố định không cần tạo lại mỗi lần count thay đổi.
              child: const Text('Chỉ số đếm bên dưới cần cập nhật:'),
              builder: (context, count, child) {
                return Column(
                  children: [
                    child!,
                    Text(
                      '$count',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                );
              },
            ),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: () => _count.value--,
                  child: const Text('-1'),
                ),
                FilledButton(
                  // Thay đổi giá trị của ValueNotifier : thay vì sử dụng setState
                  onPressed: () => _count.value++,
                  child: const Text('+1'),
                ),
                OutlinedButton(
                  // == trả về true: setter không gửi thông báo.
                  onPressed: () => _count.value = _count.value,
                  child: const Text('Gán lại cùng giá trị'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
