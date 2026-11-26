import 'package:flutter/material.dart';

class MultipleNotifiersExample extends StatefulWidget {
  const MultipleNotifiersExample({super.key});

  @override
  State<MultipleNotifiersExample> createState() =>
      _MultipleNotifiersExampleState();
}

class _MultipleNotifiersExampleState extends State<MultipleNotifiersExample> {
  // Giá trị ValueNotifier dạng int , double
  final _quantity = ValueNotifier<int>(1);
  final _unitPrice = ValueNotifier<double>(20);
  // class Listenable : Để tạo 1 đối tượng để lắng nghe
  late final Listenable _changes;

  @override
  void initState() {
    super.initState();
    // Danh sách đầu vào cố định; không thêm / xóa nguồn sau khi merge.
    // Đưa 2 giá trị ValueNotifier vào trong Listenable
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
        // Builder khi lắng nghe giá trị
        child: ListenableBuilder(
          listenable: _changes,
          builder: (context, child) {
            // ListenableBuilder không truyền value; tự đọc từ các nguồn.
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
