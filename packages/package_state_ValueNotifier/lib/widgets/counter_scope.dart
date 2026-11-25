import 'package:flutter/material.dart';

/// Chia sẻ ValueNotifier bằng Flutter SDK, không cần Provider.
class CounterScope extends InheritedNotifier<ValueNotifier<int>> {
  const CounterScope({
    super.key,
    required ValueNotifier<int> counter,
    required super.child,
  }) : super(notifier: counter);

  // Gọi trong build: đăng ký rebuild khi notifier thông báo.
  static ValueNotifier<int> watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CounterScope>();
    assert(scope != null, 'Cần đặt widget bên trong CounterScope.');
    return scope!.notifier!;
  }

  // Gọi trong callback: lấy nguồn, không đăng ký rebuild.
  static ValueNotifier<int> read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<CounterScope>();
    assert(scope != null, 'Cần đặt widget bên trong CounterScope.');
    return scope!.notifier!;
  }
}
