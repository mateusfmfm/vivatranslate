import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_controller_state.dart';

class AppControllerCubit extends Cubit<AppControllerState> {
  AppControllerCubit() : super(AppControllerInitial());

  bool _english = true;
  bool get english => _english;

  bool _spanish = false;
  bool get spanish => _spanish;

  bool _portuguese = false;
  bool get portuguese => _portuguese;

  void setEnglish() {
    emit(SelectingLanguage());
    _english = !_english;
    emit(EnglishSelected());
  }

  void setSpanish() {
    emit(SelectingLanguage());
    _spanish = !_spanish;
    emit(SpanishSelected());
  }

  void setPortuguese() {
    emit(SelectingLanguage());
    _portuguese = !_portuguese;
    emit(PortugueseSelected());
  }
}
