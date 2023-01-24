import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';
import 'package:vivatranslate_mateus/app/core/helpers/file_audio_util.dart';
import 'package:vivatranslate_mateus/app/core/theme/colors/app_colors.dart';
import 'package:vivatranslate_mateus/app/core/helpers/date_util.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/data/todo_model.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/cubit/home_cubit.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/buttons/ui_button.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/dialogs/ui_dialog.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/loaders/ui_circular_loading.dart';
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
  TextEditingController whenController = TextEditingController();
  DateTime? datePicked = DateTime.now();
  bool descriptionTyped = false;

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String? audioBase64 = "";

  final _audioRecorder = Record();

  String appDocPath = "";
  bool isRecording = false;

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
    whenController.text = AppDateUtil.formatDate(widget.todo.todoDate!);

    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileAudioUtil = FileAudioUtil(base64: widget.todo.audioBase64);
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is TranscriptionSuccessful) {
          setState(() {
            descriptionTyped = false;
            descriptionController.text = "";
            descriptionController.text = state.result!;
          });
        }
      },
      child: Padding(
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.0)),
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: Column(
                      children: [
                        Row(children: [
                          Flexible(
                              flex: 6,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                            child: TextMedium(
                                                "${widget.index! + 1}. ${widget.todo.description}")),
                                        const SizedBox(width: 8),
                                        widget.todo.audioBase64!.isEmpty
                                            ? Container()
                                            : GestureDetector(
                                                onTap: () async {
                                                  if (isPlaying) {
                                                    await audioPlayer.pause();
                                                  } else {
                                                    final File file =
                                                        await fileAudioUtil
                                                            .getFileFromBase64();

                                                    await audioPlayer.play(
                                                        DeviceFileSource(
                                                            file.path));
                                                  }
                                                },
                                                child: Icon(isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    (widget.todo.todoDate!
                                            .isBefore(DateTime.now()))
                                        ? TextMedium(
                                            "When: ${AppDateUtil.formatDate(widget.todo.todoDate!)}",
                                            fontSize: 14,
                                            fontColor: Colors.red)
                                        : TextRegular(
                                            "When: ${AppDateUtil.formatDate(widget.todo.todoDate!)}",
                                            fontSize: 14,
                                            fontColor: CustomColors.grey),
                                    const SizedBox(height: 8),
                                    if (widget.todo.location!.isNotEmpty)
                                      TextRegular(
                                          "Where: ${widget.todo.location}",
                                          fontSize: 14,
                                          fontColor: CustomColors.grey),
                                  ])),
                          (widget.todo.isCompleted!)
                              ? Icon(Icons.check_box,
                                  color: CustomColors.primaryBlue)
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                      GestureDetector(
                                          onTap: () async =>
                                              await _controller!.forward(),
                                          child: const Icon(Icons.edit)),
                                      const SizedBox(height: 16),
                                      GestureDetector(
                                          onTap: () async => await showDialog(
                                              context: context,
                                              builder: ((context) =>
                                                  _confirmFinishTodo())),
                                          child: Icon(
                                              Icons.check_box_outline_blank))
                                    ]),
                        ]),
                        SizeTransition(
                          sizeFactor: _controller!,
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            const SizedBox(height: 16),
                            BlocBuilder<HomeCubit, HomeState>(
                              builder: (context, state) {
                                return UITextField(
                                  hintText: "Description",
                                  controller: descriptionController,
                                  onChanged: (text) {
                                    setState(() {
                                      descriptionTyped = true;
                                    });
                                  },
                                  suffixIcon: InkWell(
                                    onTap: isRecording
                                        ? () async => await _stopRecord()
                                        : () async => await _startRecord(),
                                    child: (state is TranscriptionInitialized)
                                        ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: UICircularLoading(),
                                          )
                                        : isRecording
                                            ? const Icon(Icons.pause,
                                                color: Colors.red)
                                            : const Icon(Icons.mic),
                                  ),
                                );
                              },
                            ),
                            UITextField(
                              hintText: "Where?",
                              controller: whereController,
                            ),
                            UITextField(
                              hintText: "When?",
                              onTap: () async => await _getDate(),
                              controller: whenController,
                              datePicker: true,
                            ),
                            const SizedBox(height: 24),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: UIButton(
                                        label: "Save",
                                        isLoading: false,
                                        onPressed: () async {
                                          _controller!.reverse();
                                          await BlocProvider.of<HomeCubit>(
                                                  context)
                                              .performUpdateTodo(
                                                  todo: widget.todo,
                                                  audioBase64: descriptionTyped
                                                      ? ""
                                                      : audioBase64!,
                                                  description:
                                                      descriptionController
                                                          .text,
                                                  location:
                                                      whereController.text,
                                                  todoDate: datePicked);
                                        })),
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
                                  await BlocProvider.of<HomeCubit>(context)
                                      .performDeleteTodo(widget.todo);
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
      ),
    );
  }

  _confirmFinishTodo() => UIDialog(content: [
        TextRegular("Do you want to finish this ToDo?"),
        SizedBox(height: 8),
        TextLight(widget.todo.description, fontStyle: FontStyle.italic),
        SizedBox(height: 32),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final bloc = context.read<HomeCubit>();
            return Row(
              children: [
                Flexible(
                    flex: 1,
                    child: UIButton(
                        label: "Confirm",
                        isLoading: (state is PerformingFinishTodo),
                        onPressed: () async {
                          await bloc.performFinishTodo(widget.todo);
                          Navigator.of(context).pop();
                        })),
                const SizedBox(width: 16),
                Flexible(
                    flex: 1,
                    child: UIButton(
                      label: "Cancel",
                      isLoading: false,
                      secondary: true,
                      onPressed: () => Navigator.of(context).pop(),
                    ))
              ],
            );
          },
        ),
      ]);

  Future<void> _getDate() async {
    datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2025));

    whenController.text = DateFormat.yMMMd().format(datePicked!);
    setState(() {});
  }

  _startRecord() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }
        String pathTo = "$appDocPath${DateTime.now().millisecondsSinceEpoch}";
        print(pathTo);
        await _audioRecorder.start(
            path: pathTo,
            samplingRate: 16000,
            numChannels: 1,
            encoder: AudioEncoder.flac);
        isRecording = await _audioRecorder.isRecording();
        setState(() {});
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  _stopRecord() async {
    var finalPath = await _audioRecorder.stop();
    isRecording = await _audioRecorder.isRecording();
    audioBase64 = base64Encode(await File(finalPath!).readAsBytes());
    setState(() {});
    await BlocProvider.of<HomeCubit>(context)
        .transcribeDescription(finalPath.replaceAll("\\", "/"));
  }
}
