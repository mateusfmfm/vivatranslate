import 'package:flutter/material.dart';
import 'package:vivatranslate_mateus/app/core/constants/app_strings.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/scaffolds/ui_scaffold.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/texts/custom_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      body: [
        _welcomeToYour(),
      ],
    );
  }

  _welcomeToYour() => Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(children: const [
        Flexible(child: TextMedium(AppStrings.WELCOME_TO_YOUR + AppStrings.TODO_LIST)),
      ]));
}
