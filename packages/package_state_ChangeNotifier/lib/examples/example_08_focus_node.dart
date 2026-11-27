import 'package:flutter/material.dart';

class FocusNodeExample extends StatefulWidget {
  const FocusNodeExample({super.key});

  @override
  State<FocusNodeExample> createState() => _FocusNodeExampleState();
}

class _FocusNodeExampleState extends State<FocusNodeExample> {
  // FocusNode có sẵn cơ chế ChangeNotifier, không cần model bọc bên ngoài.
  // FocusNode đã được extends sẵn ChangeNotifier
  final _focus = FocusNode();

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('08. FocusNode')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListenableBuilder(
              listenable: _focus,
              // TextField không cần tạo lại chỉ vì trạng thái focus đổi.
              child: TextField(
                focusNode: _focus,
                decoration: const InputDecoration(labelText: 'Chạm để nhập'),
              ),
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(_focus.hasFocus ? 'Đang có focus' : 'Chưa có focus'),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _focus.hasFocus ? Colors.teal : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: child,
                    ),
                  ],
                );
              },
            ),
            // Thay đổi giá trị focus của Changenotifier
            TextButton(
              onPressed: _focus.unfocus,
              child: const Text('Bỏ focus'),
            ),
          ],
        ),
      ),
    );
  }
}
