// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors_in_immutables
part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HideAll extends HomeState {}

class SearchingTodo extends HomeState {}

class SearchedTodo extends HomeState {
  final List<Todo> todos;
  const SearchedTodo({required this.todos});

  @override
  List<Object> get props => [todos];
}

class AddTodoFormShow extends HomeState {}

class AddTodoFormHide extends HomeState {}

class PerformingAddTodo extends HomeState {}

class PerformingAddTodoSuccess extends HomeState {
  final List<Todo> todos;
  const PerformingAddTodoSuccess({required this.todos});

  @override
  List<Object> get props => [todos];
}

class PerformingAddTodoFailed extends HomeState {}

class PerformingDeleteToDo extends HomeState {}

class PerformingDeleteToDoSucccess extends HomeState {
  final List<Todo> todos;
  const PerformingDeleteToDoSucccess({required this.todos});

  @override
  List<Object> get props => [todos];
}

class PerformingDeleteToDoFailed extends HomeState {}

class ShowTodos extends HomeState {}

class HideTodos extends HomeState {}

class TranscriptionInitialized extends HomeState {}

class TranscriptionSuccessful extends HomeState {
  final String? result;
  TranscriptionSuccessful({required this.result});
}

class TranscriptionFailed extends HomeState {}

class AudioLoading extends HomeState {}

class AudioLoaded extends HomeState {}
