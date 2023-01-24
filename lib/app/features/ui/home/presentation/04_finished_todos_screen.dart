import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/data/models/todo_model.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/cubit/home_cubit.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/widgets/finished_todo_item.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/scaffolds/ui_scaffold.dart';
import 'package:vivatranslate_mateus/main.dart';

class FinishedTodosScreen extends StatefulWidget {
  const FinishedTodosScreen({super.key});

  @override
  State<FinishedTodosScreen> createState() => _FinishedTodosScreenState();
}

class _FinishedTodosScreenState extends State<FinishedTodosScreen> {
  late final Stream<List<Todo>> finishedTodoList;
  @override
  void initState() {
    super.initState();
    finishedTodoList = objectBox.getFinishedTodos();
  }

  @override
  Widget build(BuildContext context) {
    return UIScaffold(title: "Finished ToDos", body: [
      BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final bloc = context.read<HomeCubit>();
          return StreamBuilder<List<Todo>>(
              stream: finishedTodoList,
              builder: (context, snapshot) {
                bloc.setFinishedTodos(snapshot.data!);
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: bloc.finishedTodos.length,
                  itemBuilder: ((context, index) {
                    final data = bloc.finishedTodos[index];
                    return FinishedTodoItem(
                        index: index,
                        todo: Todo(
                            objid: data.objid,
                            id: data.id,
                            description: data.description,
                            createdAt: data.createdAt,
                            location: data.location,
                            todoDate: data.todoDate,
                            audioBase64: data.audioBase64));
                  }),
                );
              });
        },
      )
    ]);
  }
}
