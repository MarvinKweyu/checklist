

import 'package:checklist/core/error/failures.dart';
import 'package:checklist/features/checklist/data/datasources/checklist_local_source.dart';
import 'package:checklist/features/checklist/data/models/todo_model.dart';
import 'package:checklist/features/checklist/domain/entities/todo_entity.dart';
import 'package:checklist/features/checklist/domain/repositories/todo_repository.dart';
import 'package:dartz/dartz.dart';

class TodoRepositoryImpl implements TodoRepository {
  final ChecklistLocalSource localDb;

  TodoRepositoryImpl({required this.localDb});

  @override
  Future<void> addNewTodo(TodoEntity todo) async {
    final todoModel = TodoModel(
      title: todo.title,
      description: todo.description,
      isDone: todo.isDone,
    );
    await localDb.addNewTodo(todoModel);
  }

  @override
  Future<Either<Failure, TodoEntity>> getTodoById({required int id}) async {
    try {
      final todo = await localDb.getTodo(id);
      return Right(todo);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodos() async {
    try {
      final todos = await localDb.getTodos();
      return Right(todos);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeTodo({required int id}) async {
    try {
      await localDb.removeTodo(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateTodo(
      {required int id, required TodoEntity todo}) async {
    final todoModel = TodoModel(
      title: todo.title,
      description: todo.description,
      isDone: todo.isDone,
    );
    try {
      await localDb.updateTodo(id, todoModel);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}
