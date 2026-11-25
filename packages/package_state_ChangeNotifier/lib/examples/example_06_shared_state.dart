import 'package:flutter/material.dart';

import '../models/counter_model.dart';
import '../widgets/counter_scope.dart';

class SharedStateExample extends StatefulWidget {
  const SharedStateExample({super.key});

  @override
  State<SharedStateExample> createState() => _SharedStateExampleState();
}

class _SharedStateExampleState extends State<SharedStateExample> {
  final _counter = CounterModel();

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

class _FirstScreen extends StatelessWidget {
  const _FirstScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('06. Chia sẻ state')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _CounterValue(),
            const _IncrementButton(),
            OutlinedButton(
              onPressed: () {
                final counter = CounterScope.read(context);
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    // Route mới không tự nằm dưới scope của route hiện tại.
                    // Cấp lại cùng instance; route mới chỉ mượn model.
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

class _CounterValue extends StatelessWidget {
  const _CounterValue();

  @override
  Widget build(BuildContext context) {
    return Text('Bộ đếm dùng chung: ${CounterScope.watch(context).count}');
  }
}

class _IncrementButton extends StatelessWidget {
  const _IncrementButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => CounterScope.read(context).increment(),
      child: const Text('Tăng bộ đếm chung'),
    );
  }
}
