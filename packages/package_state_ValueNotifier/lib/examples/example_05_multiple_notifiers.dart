import 'package:flutter/material.dart';

class MultipleNotifiersExample extends StatefulWidget {
  const MultipleNotifiersExample({super.key});

  @override
  State<MultipleNotifiersExample> createState() =>
      _MultipleNotifiersExampleState();
}

class _MultipleNotifiersExampleState extends State<MultipleNotifiersExample> {
  final _quantity = ValueNotifier<int>(1);
  final _unitPrice = ValueNotifier<double>(20);
  late final Listenable _changes;

  @override
  void initState() {
    super.initState();
    // Danh sách đầu vào cố định; không thêm / xóa nguồn sau khi merge.
    _changes = Listenable.merge([_quantity, _unitPrice]);
  }

  @override
  void dispose() {
    // merge không sở hữu hay dispose các notifier nguồn.
    _quantity.dispose();
    _unitPrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('05. Nhiều notifier')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListenableBuilder(
          listenable: _changes,
          builder: (context, child) {
            // ListenableBuilder không truyền value; tự đọc các nguồn.
            final quantity = _quantity.value;
            final price = _unitPrice.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Số lượng: $quantity'),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: quantity > 1 ? () => _quantity.value-- : null,
                      child: const Text('Giảm'),
                    ),
                    FilledButton(
                      onPressed: () => _quantity.value++,
                      child: const Text('Tăng'),
                    ),
                  ],
                ),
                Text('Đơn giá: ${price.toStringAsFixed(0)} nghìn đồng'),
                Slider(
                  value: price,
                  min: 10,
                  max: 100,
                  divisions: 9,
                  onChanged: (value) => _unitPrice.value = value,
                ),
                Text(
                  'Tổng: ${(quantity * price).toStringAsFixed(0)} nghìn đồng',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
