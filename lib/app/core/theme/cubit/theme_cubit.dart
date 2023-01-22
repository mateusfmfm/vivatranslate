import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  bool _isDark = true;
  bool get isDark => _isDark;

  void changeTheme() {
    emit(ChangingTheme());
    _isDark = !_isDark;
    emit(ThemeChanged());
  }
}
