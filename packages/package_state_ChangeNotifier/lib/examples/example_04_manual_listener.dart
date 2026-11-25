import 'package:flutter/material.dart';

import '../models/counter_model.dart';
import '../widgets/counter_listener.dart';

class ManualListenerExample extends StatefulWidget {
  const ManualListenerExample({super.key});

  @override
  State<ManualListenerExample> createState() => _ManualListenerExampleState();
}

class _ManualListenerExampleState extends State<ManualListenerExample> {
  final _counterA = CounterModel();
  final _counterB = CounterModel();
  bool _useA = true;

  @override
  void dispose() {
    _counterA.dispose();
    _counterB.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final counter = _useA ? _counterA : _counterB;
    return Scaffold(
      appBar: AppBar(title: const Text('04. Listener thủ công')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'CounterListener dùng addListener + setState. '
              'Mốc 3, 6, 9... hiện SnackBar. Đổi A/B để thử thay nguồn.',
            ),
            SwitchListTile(
              title: Text('Đang nghe bộ đếm ${_useA ? 'A' : 'B'}'),
              value: _useA,
              // State chỉ dùng tại màn hình này vẫn có thể dùng setState.
              onChanged: (value) => setState(() => _useA = value),
            ),
            CounterListener(counter: counter),
            FilledButton(
              onPressed: counter.increment,
              child: const Text('Tăng bộ đếm đang nghe'),
            ),
          ],
        ),
      ),
    );
  }
}
