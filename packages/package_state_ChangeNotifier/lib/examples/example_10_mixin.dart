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
              'Bấm Phát để nghe file âm thanh, bấm Dừng để dừng bài hát.',
            ),
            const SizedBox(height: 12),
            const Text('Bài hát: Để dành cho em'),
            Text('Thiết bị: ${_player.name}'),
            ListenableBuilder(
              listenable: _player,
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(_player.isPlaying ? 'Đang phát' : 'Đã dừng'),
                    if (_player.error != null)
                      Text(
                        _player.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    FilledButton(
                      onPressed: _player.isBusy ? null : _player.toggle,
                      child: Text(
                        _player.isBusy
                            ? 'Đang xử lý...'
                            : _player.isPlaying
                            ? 'Dừng'
                            : 'Phát',
                      ),
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
