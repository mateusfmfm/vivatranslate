import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivatranslate_mateus/app/core/theme/colors/app_colors.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/data/todo_model.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/cubit/home_cubit.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/widgets/todo_item.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/widgets/todo_list.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/loaders/ui_circular_loading.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/scaffolds/ui_scaffold.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/textfields/ui_textfield.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/texts/custom_text.dart';
import 'package:vivatranslate_mateus/main.dart';

class ShowTodosScreen extends StatefulWidget {
  const ShowTodosScreen({super.key});

  @override
  State<ShowTodosScreen> createState() => _ShowTodosScreenState();
}

class _ShowTodosScreenState extends State<ShowTodosScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchToDoController = TextEditingController();

  late final Stream<List<Todo>> todosList;

  @override
  void initState() {
    super.initState();
    searchToDoController.addListener(() {
      BlocProvider.of<HomeCubit>(context).searchTodo(searchToDoController.text);
    });
    todosList = objectBox.getTodos();
  }

  @override
  void dispose() {
    searchToDoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      body: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {},
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final bloc = context.read<HomeCubit>();
              return Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      (bloc.todos.isEmpty)
                          ? const TextRegular(
                              "There are no ToDo here :)",
                              fontColor: CustomColors.grey,
                              fontSize: 14,
                            )
                          : UITextField(
                              hintText: "Search ToDo",
                              controller: searchToDoController,
                              preffixIcon: const Icon(Icons.search),
                            ),
                      const SizedBox(height: 24),
                      SizedBox(
                          child: StreamBuilder<List<Todo>>(
                              stream: todosList,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const UICircularLoading();
                                } else {
                                  bloc.setTodos(snapshot.data!);
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: (state is SearchedTodo)
                                        ? bloc.searchedTodos.length
                                        : bloc.todos.length,
                                    itemBuilder: ((context, index) {
                                      final data = bloc.todos[index];
                                      return TodoItem(
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
                                }
                              }))
                    ]),
              );
            },
          ),
        )
      ],
    );
  }
}
