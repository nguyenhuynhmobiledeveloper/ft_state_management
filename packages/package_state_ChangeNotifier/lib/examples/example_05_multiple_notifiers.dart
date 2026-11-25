import 'package:flutter/material.dart';

import '../models/price_model.dart';
import '../models/quantity_model.dart';

class MultipleNotifiersExample extends StatefulWidget {
  const MultipleNotifiersExample({super.key});

  @override
  State<MultipleNotifiersExample> createState() =>
      _MultipleNotifiersExampleState();
}

class _MultipleNotifiersExampleState extends State<MultipleNotifiersExample> {
  final _quantity = QuantityModel();
  final _price = PriceModel();
  late final Listenable _changes;

  @override
  void initState() {
    super.initState();
    // Iterable này phải giữ nguyên các nguồn sau khi merge.
    _changes = Listenable.merge([_quantity, _price]);
  }

  @override
  void dispose() {
    // Nguồn gộp không sở hữu hay dispose các model đầu vào.
    _quantity.dispose();
    _price.dispose();
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
            // Tổng là dữ liệu suy ra, không cần một model riêng để giữ tổng.
            final total = _quantity.quantity * _price.price;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Số lượng: ${_quantity.quantity}'),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: _quantity.quantity == 1
                          ? null
                          : _quantity.decrease,
                      child: const Text('Giảm số lượng'),
                    ),
                    FilledButton(
                      onPressed: _quantity.increase,
                      child: const Text('Tăng số lượng'),
                    ),
                  ],
                ),
                Text('Đơn giá: ${_price.price.toStringAsFixed(0)} nghìn đồng'),
                Slider(
                  value: _price.price,
                  min: 10,
                  max: 100,
                  divisions: 9,
                  onChanged: _price.setPrice,
                ),
                Text('Tổng: ${total.toStringAsFixed(0)} nghìn đồng'),
              ],
            );
          },
        ),
      ),
    );
  }
}
