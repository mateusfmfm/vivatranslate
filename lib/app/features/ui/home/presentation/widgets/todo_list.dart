import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivatranslate_mateus/app/core/theme/colors/app_colors.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/data/todo_model.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/cubit/home_cubit.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/widgets/todo_item.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/loaders/ui_circular_loading.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/textfields/ui_textfield.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/texts/custom_text.dart';
import 'package:vivatranslate_mateus/main.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  AnimationController? _controller;
  Animation<double>? _animation;
  TextEditingController searchToDoController = TextEditingController();

  late final Stream<List<Todo>> todosList;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.fastOutSlowIn,
    );
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
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is ShowTodos) {
          _controller!.forward();
        }
        if (state is HideTodos) _controller!.reverse();
        if (state is HideAll) _controller!.reverse();
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final bloc = context.read<HomeCubit>();
          return Form(
            key: _formKey,
            child: SizeTransition(
              sizeFactor: _controller!,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                (bloc.todos.isEmpty)
                    ? const TextRegular(
                        "There is no ToDo here :)",
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
                              itemCount: (state is SearchedTodo) ? bloc.searchedTodos.length : bloc.todos.length,
                              itemBuilder: ((context, index) {
                                final data = bloc.todos[index];
                                return TodoItem(
                                    index: index,
                                    todo: Todo(
                                        description: data.description,
                                        createdAt: data.createdAt,
                                        location: data.location,
                                        todoDate: data.todoDate));
                              }),
                            );
                          }
                        }))
              ]),
            ),
          );
        },
      ),
    );
  }
}
