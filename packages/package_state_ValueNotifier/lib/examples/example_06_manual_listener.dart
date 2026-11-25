import 'package:flutter/material.dart';

import '../widgets/counter_notice.dart';

class ManualListenerExample extends StatefulWidget {
  const ManualListenerExample({super.key});

  @override
  State<ManualListenerExample> createState() => _ManualListenerExampleState();
}

class _ManualListenerExampleState extends State<ManualListenerExample> {
  final _counterA = ValueNotifier<int>(0);
  final _counterB = ValueNotifier<int>(0);
  final _useA = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _counterA.dispose();
    _counterB.dispose();
    _useA.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('06. Listener thủ công')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<bool>(
          valueListenable: _useA,
          builder: (context, useA, child) {
            final counter = useA ? _counterA : _counterB;
            return CounterNotice(
              counter: counter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Mỗi mốc 3, 6, 9... sẽ hiện SnackBar. '
                    'Chuyển nguồn để thử didUpdateWidget.',
                  ),
                  SwitchListTile(
                    title: Text('Đang dùng bộ đếm ${useA ? 'A' : 'B'}'),
                    value: useA,
                    onChanged: (value) => _useA.value = value,
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: counter,
                    builder: (context, count, child) => Text('Giá trị: $count'),
                  ),
                  FilledButton(
                    onPressed: () => counter.value++,
                    child: const Text('Tăng bộ đếm đang chọn'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
