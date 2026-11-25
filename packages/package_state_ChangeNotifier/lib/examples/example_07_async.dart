import 'package:flutter/material.dart';

import '../models/message_model.dart';

class AsyncExample extends StatefulWidget {
  const AsyncExample({super.key});

  @override
  State<AsyncExample> createState() => _AsyncExampleState();
}

class _AsyncExampleState extends State<AsyncExample> {
  final _message = MessageModel();

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('07. Bất đồng bộ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bấm tải, giả lập lỗi rồi thử lại. Có thể bấm liên tiếp: '
              'model chỉ nhận kết quả của yêu cầu mới nhất.',
            ),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: () => _message.load(),
                  child: const Text('Tải thành công'),
                ),
                OutlinedButton(
                  onPressed: () => _message.load(shouldFail: true),
                  child: const Text('Giả lập lỗi'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListenableBuilder(
              listenable: _message,
              builder: (context, child) {
                switch (_message.status) {
                  case LoadStatus.initial:
                    return const Text('Chưa tải dữ liệu');
                  case LoadStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case LoadStatus.success:
                    return Text(_message.message);
                  case LoadStatus.error:
                    return Text(_message.errorMessage);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
