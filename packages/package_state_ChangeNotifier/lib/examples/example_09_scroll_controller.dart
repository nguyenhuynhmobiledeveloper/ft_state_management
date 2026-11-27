import 'package:flutter/material.dart';

class ScrollControllerExample extends StatefulWidget {
  const ScrollControllerExample({super.key});

  @override
  State<ScrollControllerExample> createState() =>
      _ScrollControllerExampleState();
}

class _ScrollControllerExampleState extends State<ScrollControllerExample> {
  // ScrollController đã được kế thừa sẵn ChangeNotifier.
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('09. ScrollController')),
      body: Column(
        children: [
          ListenableBuilder(
            listenable: _scroll,
            builder: (context, child) {
              // offset chỉ đọc được khi controller đã gắn vào một scrollable.
              // offset : khoảng cách đã cuộn của Scroll
              final offset = _scroll.hasClients ? _scroll.offset : 0.0;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Đã cuộn: ${offset.toStringAsFixed(0)} px'),
              );
            },
          ),
          Expanded(
            // ListView nằm ngoài builder nên không bị dựng lại theo offset.
            child: ListView.builder(
              controller: _scroll,
              itemCount: 50,
              itemExtent: 56,
              itemBuilder: (context, index) =>
                  ListTile(title: Text('Dòng ${index + 1}')),
            ),
          ),
          TextButton(
            onPressed: () {
              if (!_scroll.hasClients) return;
              // Dùng controller đẻ điều khiển scroll tới item 0
              _scroll.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
            child: const Text('Về đầu danh sách'),
          ),
        ],
      ),
    );
  }
}
