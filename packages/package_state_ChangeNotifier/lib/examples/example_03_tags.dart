import 'package:flutter/material.dart';

import '../models/tags_model.dart';

class TagsExample extends StatefulWidget {
  const TagsExample({super.key});

  @override
  State<TagsExample> createState() => _TagsExampleState();
}

// Ví dụ thêm thẻ vào danh sách
class _TagsExampleState extends State<TagsExample> {
  final _tags = TagsModel();
  final _input = TextEditingController(); // controller để điều khiển TextField

  // Hàm button thêm thẻ vào danh sách
  void _addTag() {
    _tags.add(_input.text);
    _input.clear();
  }

  @override
  void dispose() {
    _input.dispose();
    _tags.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('03. Danh sách thẻ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Model sửa List nội bộ rồi gọi notifyListeners. '
              'UI chỉ nhận bản sao không thể sửa.',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    onSubmitted: (_) => _addTag(),
                    decoration: const InputDecoration(labelText: 'Thẻ mới'),
                  ),
                ),
                FilledButton(onPressed: _addTag, child: const Text('Thêm thẻ')),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListenableBuilder(
                listenable: _tags,
                builder: (context, child) {
                  return ListView(
                    children: [
                      Text('Có ${_tags.count} thẻ'),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final tag in _tags.tags)
                            InputChip(
                              label: Text(tag),
                              deleteButtonTooltipMessage: 'Xóa $tag',
                              onDeleted: () => _tags.remove(tag),
                            ),
                        ],
                      ),
                      TextButton(
                        onPressed: _tags.count == 0 ? null : _tags.clear,
                        child: const Text('Xóa tất cả thẻ'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
