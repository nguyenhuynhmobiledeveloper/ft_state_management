// FilterBloc - BLoC quản lý filter (All, Active, Completed)
// Demo BLoC đơn giản với transformer

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_core/todo_core.dart';
import 'package:todo_events_states/todo_events_states.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  // Constructor: Initial state là filter All
  FilterBloc() : super(const FilterState(TodoFilter.all)) {
    // Handler cho FilterChanged
    on<FilterChanged>(_onFilterChanged);
  }

  // Handler: Thay đổi filter
  void _onFilterChanged(
    FilterChanged event,
    Emitter<FilterState> emit,
  ) {
    // Emit state mới với filter được chọn
    emit(FilterState(event.filter));
  }
}