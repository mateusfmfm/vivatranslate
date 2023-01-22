part of 'app_controller_cubit.dart';

abstract class AppControllerState extends Equatable {
  const AppControllerState();

  @override
  List<Object> get props => [];
}

class AppControllerInitial extends AppControllerState {}

class SelectingLanguage extends AppControllerState {}

class EnglishSelected extends AppControllerState {}

class PortugueseSelected extends AppControllerState {}

class SpanishSelected extends AppControllerState {}
