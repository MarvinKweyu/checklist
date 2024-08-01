part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, success, error }
// initial: launching the app
// loading: somehing is being added
// success: done adding
// error: failed to add

class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoStatus status;

  const TodoState({
    this.todos = const <Todo>[],
    this.status = TodoStatus.initial,
  });

  // change od update the state of the app

  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todos,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      status: status ?? this.status,
    );
  }

  @override
  factory TodoState.fromJson(Map<String, dynamic> json) {
    try {
      // items are stored in a map of structure: {items: [{}, {}, {}]}
      var listOfTodos = (json['todo'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();

      return TodoState(
        todos: listOfTodos,
        status: TodoStatus.values
            .firstWhere((e) => e.name.toString() == json['status']),
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'todo': todos,
      'status': status.name,
    };
  }

  @override
  List<Object> get props => [todos, status];
}
