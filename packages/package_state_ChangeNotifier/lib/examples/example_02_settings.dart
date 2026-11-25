import 'package:flutter/material.dart';

import '../models/settings_model.dart';

class SettingsExample extends StatefulWidget {
  const SettingsExample({super.key});

  @override
  State<SettingsExample> createState() => _SettingsExampleState();
}

class _SettingsExampleState extends State<SettingsExample> {
  final _settings = SettingsModel();

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('02. Nhiều thuộc tính')),
      body: ListenableBuilder(
        listenable: _settings,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Một model giữ cả màu nền và cỡ chữ. '
                'Nút áp dụng đổi hai field nhưng chỉ thông báo một lần.',
              ),
              SwitchListTile(
                title: const Text('Nền tối cho phần xem trước'),
                value: _settings.isDark,
                onChanged: _settings.setDark,
              ),
              Text('Cỡ chữ: ${_settings.fontSize.toStringAsFixed(0)}'),
              Slider(
                value: _settings.fontSize,
                min: 14,
                max: 30,
                divisions: 8,
                onChanged: _settings.setFontSize,
              ),
              Container(
                padding: const EdgeInsets.all(24),
                color: _settings.isDark ? Colors.black87 : Colors.grey.shade100,
                child: Text(
                  'Học ChangeNotifier',
                  style: TextStyle(
                    fontSize: _settings.fontSize,
                    color: _settings.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _settings.update(isDark: true, fontSize: 26),
                child: const Text('Áp dụng nền tối + chữ 26'),
              ),
              TextButton(
                onPressed: _settings.reset,
                child: const Text('Khôi phục'),
              ),
            ],
          );
        },
      ),
    );
  }
}
