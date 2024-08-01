import 'package:checklist/core/error/exception.dart';
import 'package:checklist/features/checklist/data/datasources/database.dart';
import 'package:checklist/features/checklist/data/models/todo_model.dart';
import 'package:drift/drift.dart';

abstract class ChecklistLocalSource {
  Future<void> addNewTodo(TodoModel checklist);
  Future<TodoModel> getTodo(int id);
  Future<List<TodoModel>> getTodos();
  Future<int> removeTodo(int id);
  Future<int> updateTodo(int id, TodoModel checklist);
}

class ChecklistLocalSourceImpl implements ChecklistLocalSource {
  final database = AppDatabase();

  @override
  Future<void> addNewTodo(TodoModel todo) async {
    await database.into(database.todoItems).insert(TodoItemsCompanion.insert(
        title: todo.title, description: todo.description));
  }

  @override
  Future<TodoModel> getTodo(int id) async {
    try {
      final TodoItem todoItem = await (database.select(database.todoItems)
            ..where((t) => t.id.equals(id)))
          .getSingle();

      return TodoModel(
        title: todoItem.title,
        description: todoItem.description,
        isDone: todoItem.isDone,
      );
    } catch (e) {
      throw DatabaseException();
    }
  }

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      final List<TodoItem> allItems =
          await database.select(database.todoItems).get();
      return allItems
          .map((e) => TodoModel(
                title: e.title,
                description: e.description,
                isDone: e.isDone,
              ))
          .toList();
    } catch (e) {
      throw DatabaseException();
    }
  }

  @override
  Future<int> removeTodo(int id) async {
    return (database.delete(database.todoItems)..where((t) => t.id.equals(id)))
        .go();
  }

  @override
  Future<int> updateTodo(int id, TodoModel checklist) async {
    return (database.update(database.todoItems)..where((t) => t.id.equals(id)))
        .write(TodoItemsCompanion(
      id: Value(id),
      title: Value(checklist.title),
      description: Value(checklist.description),
      isDone: Value(checklist.isDone),
    ));
  }
}
