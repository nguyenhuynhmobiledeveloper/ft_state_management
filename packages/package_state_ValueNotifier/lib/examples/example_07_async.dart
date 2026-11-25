import 'package:flutter/material.dart';

import '../controllers/message_controller.dart';
import '../models/message_state.dart';

class AsyncExample extends StatefulWidget {
  const AsyncExample({super.key});

  @override
  State<AsyncExample> createState() => _AsyncExampleState();
}

class _AsyncExampleState extends State<AsyncExample> {
  final _controller = MessageController();

  @override
  void dispose() {
    _controller.dispose();
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
              'Có thể bấm liên tiếp: chỉ yêu cầu mới nhất được ghi kết quả. '
              'Bấm tải thành công để thử lại sau lỗi.',
            ),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(
                  onPressed: () => _controller.load(),
                  child: const Text('Tải thành công'),
                ),
                OutlinedButton(
                  onPressed: () => _controller.load(shouldFail: true),
                  child: const Text('Giả lập lỗi'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<MessageState>(
              valueListenable: _controller.state,
              builder: (context, state, child) {
                switch (state.status) {
                  case LoadStatus.initial:
                    return const Text('Chưa tải dữ liệu');
                  case LoadStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case LoadStatus.success:
                    return Text(state.message);
                  case LoadStatus.error:
                    return Text(state.error);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
