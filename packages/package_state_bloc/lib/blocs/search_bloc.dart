// SearchBloc - BLoC quản lý tìm kiếm
// Demo sử dụng debounce transformer để tránh search quá nhiều lần

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../events/search_event.dart';
import '../states/search_state.dart';

// Tạo debounce transformer
// EventTransformer giúp control cách events được xử lý
EventTransformer<T> debounceTransformer<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  // Constructor: Initial state là search query rỗng
  SearchBloc() : super(const SearchState('')) {
    // Handler cho SearchQueryChangedEvent với debounce transformer
    // Debounce: chỉ xử lý event sau khi user ngừng typing 300ms
    // Tránh search quá nhiều lần khi user đang gõ
    on<SearchQueryChangedEvent>(
      _onSearchQueryChanged,
      transformer: debounceTransformer(const Duration(milliseconds: 300)),
    );

    // Handler cho SearchQueryClearedEvent
    on<SearchQueryClearedEvent>(_onSearchQueryCleared);
  }

  // Handler: Thay đổi search query
  void _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) {
    // Emit state mới với query
    emit(SearchState(event.query));
  }

  // Handler: Clear search query
  void _onSearchQueryCleared(
    SearchQueryClearedEvent event,
    Emitter<SearchState> emit,
  ) {
    // Emit state với query rỗng
    emit(const SearchState(''));
  }
}
