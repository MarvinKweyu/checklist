import 'package:checklist/core/error/failures.dart';
import 'package:checklist/features/checklist/data/datasources/checklist_local_source.dart';
import 'package:checklist/features/checklist/data/models/todo_model.dart';
import 'package:checklist/features/checklist/domain/entities/todo_entity.dart';
import 'package:checklist/features/checklist/domain/repositories/todo_repository.dart';
import 'package:dartz/dartz.dart';

import 'dart:developer' as devtools show log;

class TodoRepositoryImpl implements TodoRepository {
  final ChecklistLocalSource localDb = ChecklistLocalSourceImpl();

  @override
  Future<int> addNewTodo(TodoEntity todo) async {
    final todoModel = TodoModel(
      title: todo.title,
      description: todo.description,
      isDone: todo.isDone,
    );
    return await localDb.addNewTodo(todoModel);
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

      // convert the right to a list of TodoEntity

      final List<TodoEntity> todoList = todos.map((e) {
        return TodoEntity(
          id: e.id,
          title: e.title,
          description: e.description,
          isDone: e.isDone,
        );
      }).toList();

      return Right(todoList);
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
  Future<Either<Failure, int>> updateTodo(
      {required int id, required TodoEntity todo}) async {
    final todoModel = TodoModel(
      title: todo.title,
      description: todo.description,
      isDone: todo.isDone,
    );

    try {
      return Right(await localDb.updateTodo(id, todoModel));
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}
