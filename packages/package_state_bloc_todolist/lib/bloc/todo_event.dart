import 'package:equatable/equatable.dart';
import 'todo_state.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

final class TodosRequested extends TodoEvent {
  const TodosRequested();
}

final class TodoAdded extends TodoEvent {
  const TodoAdded(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

final class TodoToggled extends TodoEvent {
  const TodoToggled(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class TodoDeleted extends TodoEvent {
  const TodoDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class TodoFilterChanged extends TodoEvent {
  const TodoFilterChanged(this.filter);

  final TodoFilter filter;

  @override
  List<Object?> get props => [filter];
}
