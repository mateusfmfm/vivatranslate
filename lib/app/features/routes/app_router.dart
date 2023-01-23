import 'package:flutter/cupertino.dart';
import 'package:vivatranslate_mateus/app/features/routes/app_routes.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/01_home_screen.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/02_add_todos_screen.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/03_show_todos_screen.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/04_finished_todos_screen.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/05_extras_screen.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    var arguments = settings.arguments;
    _withArguments() =>
        arguments.toString() != "null" ? " with arguments: $arguments" : "";

    print("[APP] GOING TO ROUTE: '${settings.name}${_withArguments()}'");
    switch (settings.name) {
      case Routes.HOME:
        return _animateTo(HomeScreen());
      case Routes.ADD_TODOS:
        return _animateTo(AddTodosScreen());
      case Routes.SHOW_TODOS:
        return _animateTo(ShowTodosScreen());
      case Routes.FINISHED_TODOS:
        return _animateTo(FinishedTodosScreen());
      case Routes.EXTRAS:
        return _animateTo(ExtrasScreen());
      
      default:
        throw Center(
            child: Text("There's no page defined for route ${settings.name}"));
    }
  }

  _animateTo(page) => PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child));
}