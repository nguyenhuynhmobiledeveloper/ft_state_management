import 'package:flutter/material.dart';

class ToggleExample extends StatefulWidget {
  const ToggleExample({super.key});

  @override
  State<ToggleExample> createState() => _ToggleExampleState();
}

class _ToggleExampleState extends State<ToggleExample> {
  // Giá trị ValueNotifier dạng bool
  final _hidePassword = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _hidePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('02. Bật / tắt')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<bool>(
          valueListenable: _hidePassword,
          builder: (context, isHidden, child) {
            debugPrint('isHidden $isHidden');
            return TextField(
              obscureText: isHidden, // Ẩn văn bản
              decoration: InputDecoration(
                labelText: 'Nhập mật khẩu thử nghiệm',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: isHidden ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
                  onPressed: () => _hidePassword.value = !isHidden,
                  icon: Icon(
                    isHidden ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
