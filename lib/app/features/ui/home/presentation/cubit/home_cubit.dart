import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/speech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/data/repository/home_repository.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/data/models/todo_model.dart';
import 'package:vivatranslate_mateus/main.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  HomeRepository homeRepository = HomeRepository();

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  List<Todo> _finishedTodos = [];
  List<Todo> get finishedTodos => _finishedTodos;

  List<Todo> _searchedTodos = [];
  List<Todo> get searchedTodos => _searchedTodos;

  String _audioTranscription = '';
  String get audioTranscription => _audioTranscription;

  setTodos(List<Todo> storedTodos) => _todos = storedTodos;
  setFinishedTodos(List<Todo> finishedTodos) => _finishedTodos = finishedTodos;

  searchTodo(String value) {
    emit(SearchingTodo());
    if (value.isEmpty) {
      emit(HomeInitial());
    } else {
      _searchedTodos = _todos
          .where((todo) =>
              todo.description!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      emit(SearchedTodo(todos: _searchedTodos));
    }
  }

  performAddTodo(Todo todo) async {
    try {
      emit(PerformingAddTodo());

      objectBox.insertTodo(todo);

      emit(PerformingAddTodoSuccess(todos: _todos));
    } catch (e) {
      debugPrint('$e');
      emit(PerformingAddTodoFailed());
    }
  }

  performDeleteTodo(Todo todo) async {
    try {
      emit(PerformingDeleteToDo());
      objectBox.deleteTodo(todo.id!);
      await Future.delayed(const Duration(milliseconds: 300));
      emit(PerformingDeleteToDoSucccess(todos: _todos));
    } catch (e) {
      print('$e');
      emit(PerformingAddTodoFailed());
    }
  }

  performFinishTodo(Todo todo) async {
    try {
      final updatedTodo = Todo(
          createdAt: todo.createdAt,
          description: todo.description,
          id: todo.id,
          objid: todo.objid,
          audioBase64: todo.audioBase64,
          isCompleted: true,
          location: todo.location,
          todoDate: todo.todoDate);
      emit(PerformingFinishTodo());
      objectBox.finishTodo(updatedTodo);
      await Future.delayed(const Duration(milliseconds: 300));
      emit(PerformingFinishTodoSuccesful(todos: _todos));
    } catch (e) {
      debugPrint('$e');
      emit(PerformingFinishTodoFailed());
    }
  }

  performUpdateTodo(
      {Todo? todo,
      String? description,
      String? audioBase64,
      String? location,
      DateTime? todoDate}) async {
    try {
      final updatedTodo = Todo(
          createdAt: todo!.createdAt,
          description: description ?? todo.description,
          id: todo.id,
          objid: todo.objid,
          audioBase64: audioBase64 ?? todo.audioBase64,
          isCompleted: todo.isCompleted,
          location: location ?? todo.location,
          todoDate: todoDate ?? todo.todoDate);
      emit(PerformingUpdateTodo());
      objectBox.updateTodo(updatedTodo);
      await Future.delayed(const Duration(milliseconds: 300));
      emit(PerformingUpdateTodoSuccesful(todos: _todos));
    } catch (e) {
      debugPrint('$e');
      emit(PerformingUpdateTodoFailed());
    }
  }

  transcribeDescription(String audioPath) async {
    try {
      emit(TranscriptionInitialized());
      _audioTranscription = await homeRepository.transcribeAudio(audioPath);
      emit(TranscriptionSuccessful(result: _audioTranscription));
    } catch (e) {
      debugPrint('$e');
      await File(audioPath).delete();
      emit(TranscriptionFailed());
    }
  }
}
