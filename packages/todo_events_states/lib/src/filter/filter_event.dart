// File định nghĩa các Events cho FilterBloc
import 'package:equatable/equatable.dart';
import 'package:todo_core/todo_core.dart';

// Base class cho FilterEvents
abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object?> get props => [];
}

// Event: Thay đổi filter
class FilterChanged extends FilterEvent {
  final TodoFilter filter;

  const FilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}