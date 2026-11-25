import 'package:flutter/material.dart';

import '../examples/example_01_counter.dart';
import '../examples/example_02_settings.dart';
import '../examples/example_03_tags.dart';
import '../examples/example_04_manual_listener.dart';
import '../examples/example_05_multiple_notifiers.dart';
import '../examples/example_06_shared_state.dart';
import '../examples/example_07_async.dart';
import '../examples/example_08_focus_node.dart';
import '../examples/example_09_scroll_controller.dart';
import '../examples/example_10_mixin.dart';

class ExamplesScreen extends StatelessWidget {
  const ExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Học ChangeNotifier')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Mỗi ví dụ tập trung vào một tình huống. '
            'Đọc file model trước, sau đó xem cách widget lắng nghe.',
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

class _Example {
  const _Example(this.title, this.description, this.screen);

  final String title;
  final String description;
  final Widget screen;
}

const _examples = [
  _Example(
    '01. Counter',
    'notifyListeners, ListenableBuilder và child',
    CounterExample(),
  ),
  _Example(
    '02. Nhiều thuộc tính',
    'Cập nhật nhiều field, thông báo một lần',
    SettingsExample(),
  ),
  _Example(
    '03. Danh sách thẻ',
    'List nội bộ và dữ liệu chỉ đọc',
    TagsExample(),
  ),
  _Example(
    '04. Listener thủ công',
    'addListener, setState, SnackBar và vòng đời',
    ManualListenerExample(),
  ),
  _Example(
    '05. Nhiều notifier',
    'Listenable.merge và dữ liệu suy ra',
    MultipleNotifiersExample(),
  ),
  _Example(
    '06. Chia sẻ state',
    'InheritedNotifier giữa widget và route',
    SharedStateExample(),
  ),
  _Example(
    '07. Bất đồng bộ',
    'Loading, lỗi, thử lại và dispose',
    AsyncExample(),
  ),
  _Example(
    '08. FocusNode',
    'Nghe ChangeNotifier có sẵn trong SDK',
    FocusNodeExample(),
  ),
  _Example(
    '09. ScrollController',
    'Nghe vị trí cuộn, giới hạn vùng rebuild',
    ScrollControllerExample(),
  ),
  _Example(
    '10. ChangeNotifier làm mixin',
    'Đã có class cha vẫn thêm được listener',
    MixinExample(),
  ),
];
