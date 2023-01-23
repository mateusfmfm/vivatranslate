import 'package:flutter/src/widgets/framework.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/widgets/todo_list.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/scaffolds/ui_scaffold.dart';

class ShowTodosScreen extends StatefulWidget {
  const ShowTodosScreen({super.key});

  @override
  State<ShowTodosScreen> createState() => _ShowTodosScreenState();
}

class _ShowTodosScreenState extends State<ShowTodosScreen> {
  @override
  Widget build(BuildContext context) {
    return const UIScaffold(body: [
      TodoList(),
    ],);
  }
}