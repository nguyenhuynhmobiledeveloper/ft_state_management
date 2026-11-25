import 'package:flutter/material.dart';

class ListExample extends StatefulWidget {
  const ListExample({super.key});

  @override
  State<ListExample> createState() => _ListExampleState();
}

class _ListExampleState extends State<ListExample> {
  final _items = ValueNotifier<List<String>>(const []);
  int _nextNumber = 1;

  void _addItem() {
    // SAI với list có thể sửa: _items.value.add('Mới');
    // Sửa tại chỗ không đi qua setter value nên không phát thông báo.
    // ĐÚNG: tạo list mới và gán lại value.
    _items.value = [..._items.value, 'Mục ${_nextNumber++}'];
  }

  void _removeItem(int index) {
    final newItems = [..._items.value];
    newItems.removeAt(index);
    _items.value = newItems;
  }

  @override
  void dispose() {
    _items.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('03. Danh sách')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Mỗi lần thêm / xóa đều tạo List mới rồi gán vào value.',
            ),
          ),
          FilledButton(onPressed: _addItem, child: const Text('Thêm một mục')),
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _items,
              builder: (context, items, child) {
                if (items.isEmpty) {
                  return const Center(child: Text('Danh sách trống'));
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(items[index]),
                    trailing: IconButton(
                      tooltip: 'Xóa ${items[index]}',
                      onPressed: () => _removeItem(index),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
