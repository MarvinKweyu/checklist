import 'package:bloc/bloc.dart';
import 'package:checklist/core/error/failures.dart';
import 'package:checklist/features/checklist/data/repositories/todo_repository_impl.dart';
import 'package:checklist/features/checklist/domain/entities/todo_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'dart:developer' as devtools show log;

part 'checklist_event.dart';
part 'checklist_state.dart';

class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  ChecklistBloc() : super(ChecklistInitial()) {
    on<ChecklistStarted>(_onStarted);
    on<AddTodo>(_onAddTodo);
    on<FetchTodos>(_onFetchTodos);
    on<FetchTodosById>(_onFetchTodoById);
    on<RemoveTodo>(_onRemoveTodo);
    on<UpdateTodo>(_onUpdateTodo);
  }

  TodoRepositoryImpl checklistRepo = TodoRepositoryImpl();

  void _onStarted(ChecklistStarted event, Emitter<ChecklistState> emit) async {
    // _fetchAll(emit);
    emit(state.copyWith(status: ChecklistStatus.loading));
    try {
      Either<Failure, List<TodoEntity>> allItems =
          await checklistRepo.getTodos();
      if (allItems.isLeft()) {
        emit(state.copyWith(status: ChecklistStatus.error));
        return;
      }

      // get the items to the right
      var res = allItems.getOrElse(() => []);

      emit(state.copyWith(todos: res, status: ChecklistStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ChecklistStatus.error));
    }
  }

  void _onAddTodo(AddTodo event, Emitter<ChecklistState> emit) async {
    emit(state.copyWith(status: ChecklistStatus.loading));
    try {
      int todoId = await checklistRepo.addNewTodo(event.todo);

      List<TodoEntity> temp = [];
      temp.addAll(state.todos);
      final TodoEntity updatedTodo = event.todo.copyWith(id: todoId);

      temp.insert(0, updatedTodo);
      emit(state.copyWith(todos: temp, status: ChecklistStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ChecklistStatus.error));
    }
  }

  void _onFetchTodos(FetchTodos event, Emitter<ChecklistState> emit) async {
    // _fetchAll(emit);

    emit(state.copyWith(status: ChecklistStatus.loading));
    try {
      Either<Failure, List<TodoEntity>> allItems =
          await checklistRepo.getTodos();
      if (allItems.isLeft()) {
        emit(state.copyWith(status: ChecklistStatus.error));
        return;
      }

      // get the items to the right
      var res = allItems.getOrElse(() => []);

      emit(state.copyWith(todos: res, status: ChecklistStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ChecklistStatus.error));
    }
  }

  void _onFetchTodoById(
      FetchTodosById event, Emitter<ChecklistState> emit) async {
    emit(state.copyWith(status: ChecklistStatus.loading));
    try {
      final todo = state.todos.firstWhere((element) => element.id == event.id);
      emit(state.copyWith(todos: [todo], status: ChecklistStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ChecklistStatus.error));
    }
  }

  void _onRemoveTodo(RemoveTodo event, Emitter<ChecklistState> emit) async {
    emit(state.copyWith(status: ChecklistStatus.loading));
    try {
      await checklistRepo.removeTodo(id: event.todo.id!);
      state.todos.remove(event.todo);
      emit(state.copyWith(todos: state.todos, status: ChecklistStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ChecklistStatus.error));
    }
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<ChecklistState> emit) async {
    emit(state.copyWith(status: ChecklistStatus.loading));
    devtools.log(event.updatedTodo.toString());

    try {
      var res =
          await checklistRepo.updateTodo(id: event.id, todo: event.updatedTodo);
      if (res.isLeft()) {
        emit(state.copyWith(status: ChecklistStatus.error));
        return;
      }

      final index = state.todos.indexWhere((element) => element.id == event.id);
      // extra check that it already existed
      if (index == -1) {
        emit(state.copyWith(status: ChecklistStatus.error));
        return;
      }
      devtools.log("Updating an item..");
      devtools.log(event.updatedTodo.runtimeType.toString());
      devtools.log("Updating on");
      devtools.log(state.todos.runtimeType.toString());
      List<TodoEntity> updatedTodos = List.from(state.todos);
      updatedTodos[index] = event.updatedTodo;

      // state.todos[index] = event.updatedTodo;
      emit(
          state.copyWith(todos: updatedTodos, status: ChecklistStatus.success));
    } catch (e) {
      devtools.log(e.toString());
      emit(state.copyWith(status: ChecklistStatus.error));
    }
  }
}
