import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vivatranslate_mateus/app/core/helpers/bloc_observer.dart';
import 'package:vivatranslate_mateus/app/core/helpers/objectbox.dart';
import 'package:vivatranslate_mateus/app/core/theme/colors/app_colors.dart';
import 'package:vivatranslate_mateus/app/core/theme/cubit/theme_cubit.dart';
import 'package:vivatranslate_mateus/app/features/routes/app_router.dart';
import 'package:vivatranslate_mateus/app/features/routes/app_routes.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/01_home_screen.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/cubit/home_cubit.dart';

late ObjectBox objectBox;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.init();
  Bloc.observer = AppBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => HomeCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeCubit>(context, listen: true);
    return MaterialApp(
        title: 'Viva Translate',
        debugShowCheckedModeBanner: false,
        theme: theme.isDark ? CustomColors.darkTheme : ThemeData.light(),
        home: const HomeScreen(),
        builder: (context, child) => ResponsiveWrapper.builder(
              child!,
              maxWidth: 1080,
              minWidth: 360,
              breakpoints: const [ResponsiveBreakpoint.resize(1080)],
            ),
        onGenerateRoute: AppRouter().onGenerateRoute,
        initialRoute: Routes.HOME);
  }
}
