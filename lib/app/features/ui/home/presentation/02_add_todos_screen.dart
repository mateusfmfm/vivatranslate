
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/widgets/add_todo_form.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/scaffolds/ui_scaffold.dart';

class AddTodosScreen extends StatefulWidget {
  const AddTodosScreen({super.key});

  @override
  State<AddTodosScreen> createState() => _AddTodosScreenState();
}

class _AddTodosScreenState extends State<AddTodosScreen> {
  @override
  Widget build(BuildContext context) {
    return UIScaffold(body: [AddTodoForm()]);
  }
}