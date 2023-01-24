import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/speech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/data/todo_model.dart';
import 'package:vivatranslate_mateus/main.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

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
      objectBox.insertTodo(todo);

      await Future.delayed(const Duration(milliseconds: 300));
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
          location: todo.location, todoDate: todo.todoDate);
      emit(PerformingFinishTodo());
      objectBox.finishTodo(updatedTodo);
      await Future.delayed(const Duration(milliseconds: 300));
      emit(PerformingFinishTodoSuccesful(todos: _todos));
    } catch (e) {
      debugPrint('$e');
      emit(PerformingFinishTodoFailed());
    }
  }

  transcribeDescription(String audioPath) async {
    try {
      emit(TranscriptionInitialized());
      final credentials = ServiceAccountCredentials.fromJson(await rootBundle
          .loadString('assets/.keys/challenges-374904-4e20da4930a2.json'));
      const scopes = [SpeechApi.cloudPlatformScope];

      await clientViaServiceAccount(credentials, scopes).then((httpClient) {
        var speech = SpeechApi(httpClient);
        try {
          _readFileByte(audioPath).then((bytesData) async {
            String audioString = base64.encode(bytesData);
            RecognizeRequest r = RecognizeRequest();
            RecognitionAudio audio =
                RecognitionAudio.fromJson({'content': audioString});
            r.audio = audio;
            RecognitionConfig config = RecognitionConfig.fromJson({
              "encoding": "FLAC",
              "sampleRateHertz": 16000,
              "languageCode": "en-US",
            });
            r.config = config;
            await speech.speech.recognize(r).then((results) {
              for (var result in results.results!) {
                _audioTranscription = result.alternatives![0].transcript!;
              }

              emit(TranscriptionSuccessful(result: _audioTranscription));
              log(_audioTranscription);
            }).catchError((error) => print('$error'));
          });
        } catch (e) {
          print(e);
        }
      });
    } catch (e) {
      debugPrint('$e');
      await File(audioPath).delete();
      emit(TranscriptionFailed());
    }
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    File audioFile = File(filePath);
    Uint8List bytes;
    var result = await audioFile.readAsBytes();
    bytes = Uint8List.fromList(result);
    return bytes;
  }
}
