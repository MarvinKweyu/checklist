part of 'checklist_bloc.dart';

enum ChecklistStatus { initial, loading, success, error }

class ChecklistState extends Equatable {
  final List<TodoEntity> todos;
  final ChecklistStatus status;
  const ChecklistState({
    this.todos = const <TodoEntity>[],
    this.status = ChecklistStatus.initial,
  });

  ChecklistState copyWith({
    ChecklistStatus? status,
    List<TodoEntity>? todos,
  }) {
    return ChecklistState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [todos, status];
}

class ChecklistInitial extends ChecklistState {}
