import 'package:flutter/material.dart';

import '../widgets/counter_scope.dart';

class SharedStateExample extends StatefulWidget {
  const SharedStateExample({super.key});

  @override
  State<SharedStateExample> createState() => _SharedStateExampleState();
}

class _SharedStateExampleState extends State<SharedStateExample> {
  // Tạo ra 1 giá trị ValueNotifier - sau đó sẽ đượct truyền vào cho CounterScope
  final _counter = ValueNotifier<int>(0);

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CounterScope(counter: _counter, child: const _FirstScreen());
  }
}

// Màn hình thứ nhất
class _FirstScreen extends StatelessWidget {
  const _FirstScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('08. Chia sẻ state')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Hai màn hình dùng chung một ValueNotifier.'),
            const _CounterValue(),
            const _IncrementButton(),
            OutlinedButton(
              onPressed: () {
                // Lấy ra giá trị counter được lấy từ CounterScope
                final counter = CounterScope.read(context);
                // Chuyển sang màn hình thứ 2
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    // Route mới không tự nằm dưới scope của route hiện tại.
                    // Truyền cùng instance; màn hình phụ không dispose nó.
                    builder: (_) => CounterScope(
                      counter: counter,
                      child: const _SecondScreen(),
                    ),
                  ),
                );
              },
              child: const Text('Mở màn hình thứ hai'),
            ),
          ],
        ),
      ),
    );
  }
}

// Màn hình thứ 2
class _SecondScreen extends StatelessWidget {
  const _SecondScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Màn hình thứ hai')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_CounterValue(), _IncrementButton()],
        ),
      ),
    );
  }
}

// Widget common để sử dụng chung
class _CounterValue extends StatelessWidget {
  const _CounterValue();

  @override
  Widget build(BuildContext context) {
    final count = CounterScope.watch(context).value;
    return Text('Bộ đếm dùng chung: $count');
  }
}

// Widget common để sử dụng chung
class _IncrementButton extends StatelessWidget {
  const _IncrementButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      // Tăng gía trị của state trong CounterScope lên 1
      onPressed: () => CounterScope.read(context).value++,
      child: const Text('Tăng bộ đếm chung'),
    );
  }
}
