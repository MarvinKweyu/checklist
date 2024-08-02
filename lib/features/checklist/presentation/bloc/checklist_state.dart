part of 'checklist_bloc.dart';

enum ChecklistStatus { initial, loading, success, error }

class ChecklistState extends Equatable {
  final List<TodoEntity> todos;
  final List<TodoEntity> completedTodos;
  final List<TodoEntity> incompleteTodos;

  final ChecklistStatus status;
  const ChecklistState({
    this.todos = const <TodoEntity>[],
    this.completedTodos = const <TodoEntity>[],
    this.incompleteTodos = const <TodoEntity>[],
    this.status = ChecklistStatus.initial,
  });

  ChecklistState copyWith({
    ChecklistStatus? status,
    List<TodoEntity>? todos,
    List<TodoEntity>? completedTodos,
    List<TodoEntity>? incompleteTodos,
  }) {
    final updatedTodos = todos ?? this.todos;

    // Filter completed and incomplete todos based on updatedTodos
    final filteredCompletedTodos =
        completedTodos ?? updatedTodos.where((todo) => todo.isDone).toList();
    final filteredIncompleteTodos = incompleteTodos ??
        updatedTodos.where((todo) => todo.isDone == false).toList();

    return ChecklistState(
      todos: todos ?? this.todos,
      completedTodos: filteredCompletedTodos,
      incompleteTodos: filteredIncompleteTodos,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [todos, completedTodos, incompleteTodos, status];
}

class ChecklistInitial extends ChecklistState {}
