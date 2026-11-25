import 'package:flutter/material.dart';

import '../models/player_model.dart';

class MixinExample extends StatefulWidget {
  const MixinExample({super.key});

  @override
  State<MixinExample> createState() => _MixinExampleState();
}

class _MixinExampleState extends State<MixinExample> {
  final _player = PlayerModel();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('10. ChangeNotifier làm mixin')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'PlayerModel extends AudioDevice with ChangeNotifier. '
              'Đây chỉ là trạng thái phát / dừng giả lập, không phát âm thanh.',
            ),
            Text('Thiết bị: ${_player.name}'),
            ListenableBuilder(
              listenable: _player,
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(_player.isPlaying ? 'Đang phát' : 'Đã dừng'),
                    FilledButton(
                      onPressed: _player.toggle,
                      child: Text(_player.isPlaying ? 'Dừng' : 'Phát'),
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
