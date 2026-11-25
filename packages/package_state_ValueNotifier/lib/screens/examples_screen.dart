import 'package:flutter/material.dart';

import '../examples/example_01_counter.dart';
import '../examples/example_02_toggle.dart';
import '../examples/example_03_list.dart';
import '../examples/example_04_text_input.dart';
import '../examples/example_05_multiple_notifiers.dart';
import '../examples/example_06_manual_listener.dart';
import '../examples/example_07_async.dart';
import '../examples/example_08_shared_state.dart';

class ExamplesScreen extends StatelessWidget {
  const ExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Học ValueNotifier')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Mở từng ví dụ theo thứ tự. Mỗi màn hình tập trung vào một vấn đề, '
            'chỉ dùng các class có sẵn trong Flutter SDK.',
          ),
          const SizedBox(height: 12),
          for (final example in _examples)
            Card(
              child: ListTile(
                title: Text(example.title),
                subtitle: Text(example.description),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute<void>(builder: (_) => example.screen)),
              ),
            ),
        ],
      ),
    );
  }
}

// Chỉ chứa thông tin menu, không quản lý state.
class _Example {
  const _Example(this.title, this.description, this.screen);

  final String title;
  final String description;
  final Widget screen;
}

const _examples = [
  _Example('01. Counter', 'value, ==, builder và child', CounterExample()),
  _Example('02. Bật / tắt', 'ValueNotifier<bool>', ToggleExample()),
  _Example('03. Danh sách', 'Thay List bằng List mới', ListExample()),
  _Example(
    '04. Ô nhập liệu',
    'TextEditingController cũng là ValueNotifier',
    TextInputExample(),
  ),
  _Example(
    '05. Nhiều notifier',
    'Listenable.merge và ListenableBuilder',
    MultipleNotifiersExample(),
  ),
  _Example(
    '06. Listener thủ công',
    'Side effect và vòng đời listener',
    ManualListenerExample(),
  ),
  _Example(
    '07. Bất đồng bộ',
    'Initial / loading / success / error',
    AsyncExample(),
  ),
  _Example(
    '08. Chia sẻ state',
    'InheritedNotifier giữa widget và màn hình',
    SharedStateExample(),
  ),
];
