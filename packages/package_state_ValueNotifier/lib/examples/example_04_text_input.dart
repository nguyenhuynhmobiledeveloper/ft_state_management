import 'package:flutter/material.dart';

class TextInputExample extends StatefulWidget {
  const TextInputExample({super.key});

  @override
  State<TextInputExample> createState() => _TextInputExampleState();
}

class _TextInputExampleState extends State<TextInputExample> {
  // TextEditingController kế thừa ValueNotifier<TextEditingValue>.
  // Không cần tạo thêm ValueNotifier<String> để giữ cùng nội dung.
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('04. Ô nhập liệu')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _text,
              decoration: const InputDecoration(
                labelText: 'Tên của bạn',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _text,
              builder: (context, editingValue, child) {
                final name = editingValue.text.trim();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(name.isEmpty ? 'Chưa nhập tên' : 'Xin chào $name!'),
                    Text('${editingValue.text.characters.length} ký tự'),
                    Text(
                      'Vị trí con trỏ: ${editingValue.selection.baseOffset}',
                    ),
                    FilledButton(
                      onPressed: name.isEmpty ? null : _text.clear,
                      child: const Text('Xóa nội dung'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
