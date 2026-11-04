// File định nghĩa các Events cho FilterBloc
import 'package:equatable/equatable.dart';
import '../models/todo_filter.dart';

// Base class cho FilterEvents
abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

// Event: Thay đổi giá trị filter - nhận vào 1 giá trị enum của TodoFilter
class FilterChangedEvent extends FilterEvent {
  final TodoFilter filter;

  const FilterChangedEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
