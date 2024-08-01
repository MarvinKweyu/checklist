part of 'checklist_bloc.dart';

abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();

  @override
  List<Object> get props => [];
}

class ChecklistStarted extends ChecklistEvent {}

class AddTodo extends ChecklistEvent {
  final TodoEntity todo;

  const AddTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'AddTodo { todo: $todo }';
}

class FetchTodos extends ChecklistEvent {
  const FetchTodos();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'FetchTodos';
}

class FetchTodosById extends ChecklistEvent {
  final int id;

  const FetchTodosById(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'FetchTodosById { id: $id }';
}

class RemoveTodo extends ChecklistEvent {
  final TodoEntity todo;

  const RemoveTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'RemoveTodo { todo: $todo }';
}

class UpdateTodo extends ChecklistEvent {
  final int id;
  final TodoEntity updatedTodo;

  const UpdateTodo(this.id, this.updatedTodo);

  @override
  List<Object> get props => [id, updatedTodo];

  @override
  String toString() => 'UpdateTodo { updatedTodo: $updatedTodo }';
}
