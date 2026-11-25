import 'package:flutter/material.dart';

import '../models/counter_model.dart';

class CounterExample extends StatefulWidget {
  const CounterExample({super.key});

  @override
  State<CounterExample> createState() => _CounterExampleState();
}

class _CounterExampleState extends State<CounterExample> {
  // Tạo một lần trong State, không tạo lại trong build.
  final _counter = CounterModel();

  @override
  void dispose() {
    _counter.dispose(); // Widget tạo model cũng là chủ sở hữu model.
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
            ListenableBuilder(
              listenable: _counter,
              // Phần không phụ thuộc count được truyền vào child để dùng lại.
              child: const Text('Số đếm hiện tại:'),
              builder: (context, child) {
                // ChangeNotifier không có thuộc tính value mặc định.
                return Column(
                  children: [
                    child!,
                    Text(
                      '${_counter.count}',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                );
              },
            ),
            // AnimatedBuilder cũng nhận Listenable, không chỉ Animation.
            AnimatedBuilder(
              animation: _counter,
              builder: (context, child) =>
                  Text('AnimatedBuilder cũng đọc: ${_counter.count}'),
            ),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: _counter.decrement,
                  child: const Text('-1'),
                ),
                FilledButton(
                  onPressed: _counter.increment,
                  child: const Text('+1'),
                ),
                TextButton(
                  onPressed: _counter.reset,
                  child: const Text('Đặt lại'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
