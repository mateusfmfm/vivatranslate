import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivatranslate_mateus/app/core/theme/colors/app_colors.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/data/todo_model.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/cubit/home_cubit.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/buttons/ui_button.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/textfields/ui_textfield.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/texts/custom_text.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({super.key, required this.todo, required this.index});

  final Todo todo;
  final int? index;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  AnimationController? _controller;
  Animation<double>? _animation;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController whereController = TextEditingController();

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
    descriptionController.text = widget.todo.description!;
    whereController.text = widget.todo.location!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
          decoration: const BoxDecoration(
            gradient: CustomColors.gradient,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: Column(
                    children: [
                      Row(children: [
                        Flexible(
                            flex: 6,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(
                                children: [
                                  Flexible(child: TextMedium("${widget.index! + 1}. ${widget.todo.description}")),
                                  const SizedBox(width: 8),
                                  GestureDetector(child: const Icon(Icons.play_arrow)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextRegular("When: ${widget.todo.createdAt}", fontSize: 14, fontColor: CustomColors.grey),
                              const SizedBox(height: 8),
                              if (widget.todo.location != null)
                                TextRegular("Where: ${widget.todo.location}",
                                    fontSize: 14, fontColor: CustomColors.grey),
                            ])),
                        Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          GestureDetector(
                              onTap: () async => await _controller!.forward(), child: const Icon(Icons.edit)),
                          const SizedBox(height: 16),
                          GestureDetector(child: const Icon(Icons.check_box_outline_blank)),
                        ]),
                      ]),
                      SizeTransition(
                        sizeFactor: _controller!,
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          const SizedBox(height: 16),
                          UITextField(
                            hintText: "Description",
                            controller: descriptionController,
                          ),
                          UITextField(hintText: "Where", controller: whereController),
                          const UITextField(hintText: "When"),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Flexible(
                                  flex: 1, child: UIButton(label: "Save", isLoading: false, onPressed: () async {})),
                              const SizedBox(width: 16),
                              Flexible(
                                  flex: 1,
                                  child: UIButton(
                                    label: "Cancel",
                                    isLoading: false,
                                    secondary: true,
                                    onPressed: () {
                                      _controller!.reverse();
                                    },
                                  ))
                            ],
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () async {
                                await BlocProvider.of<HomeCubit>(context).performDeleteTodo(widget.todo);
                              },
                              child: const TextRegular(
                                "Delete item",
                                underline: true,
                                fontColor: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          )
                        ]),
                      )
                    ],
                  )))),
    );
  }
}
