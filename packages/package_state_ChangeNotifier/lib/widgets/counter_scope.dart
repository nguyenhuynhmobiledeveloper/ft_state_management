import 'package:flutter/material.dart';

import '../models/counter_model.dart';

/// Cấp model cho cây con và cập nhật các widget đăng ký phụ thuộc.
class CounterScope extends InheritedNotifier<CounterModel> {
  const CounterScope({
    super.key,
    required CounterModel counter,
    required super.child,
  }) : super(notifier: counter);

  // Dùng trong build: đăng ký widget cần rebuild khi model thông báo.
  static CounterModel watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CounterScope>();
    assert(scope != null, 'Cần đặt widget trong CounterScope.');
    return scope!.notifier!;
  }

  // Dùng trong callback: lấy model mà không đăng ký rebuild.
  static CounterModel read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<CounterScope>();
    assert(scope != null, 'Cần đặt widget trong CounterScope.');
    return scope!.notifier!;
  }
}
