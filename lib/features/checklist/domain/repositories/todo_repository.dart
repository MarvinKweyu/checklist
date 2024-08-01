import 'package:checklist/core/error/failures.dart';
import 'package:checklist/features/checklist/domain/entities/todo_entity.dart';
import 'package:dartz/dartz.dart';

abstract class TodoRepository {
  Future<void> addNewTodo(TodoEntity todo);
  Future<Either<Failure, TodoEntity>> getTodoById({required int id});
  Future<Either<Failure, List<TodoEntity>>> getTodos();
  Future<Either<Failure, void>> removeTodo({required int id});
  Future<Either<Failure, void>> updateTodo({required int id, required TodoEntity todo});
}
