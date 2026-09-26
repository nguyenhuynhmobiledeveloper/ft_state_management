// File định nghĩa các States cho FilterBloc
import 'package:equatable/equatable.dart';
import 'package:todo_core/todo_core.dart';

// FilterState đơn giản, chỉ chứa filter hiện tại
class FilterState extends Equatable {
  final TodoFilter filter;

  const FilterState(this.filter);

  @override
  List<Object?> get props => [filter];
}