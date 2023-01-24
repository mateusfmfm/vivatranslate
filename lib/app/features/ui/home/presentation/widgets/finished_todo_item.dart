import 'dart:convert';
import 'dart:developer';
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
import 'package:path_provider/path_provider.dart';

class FinishedTodoItem extends StatefulWidget {
  const FinishedTodoItem({super.key, required this.todo, required this.index});

  final Todo? todo;
  final int? index;

  @override
  State<FinishedTodoItem> createState() => _FinishedTodoItemState();
}

class _FinishedTodoItemState extends State<FinishedTodoItem> {
  DateTime? datePicked = DateTime.now();

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String? audioBase64 = "";

  String appDocPath = "";

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileAudioUtil = FileAudioUtil(base64: widget.todo!.audioBase64);
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.0)),
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: Column(children: [
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
                                              "${widget.index! + 1}. ${widget.todo!.description}")),
                                      const SizedBox(width: 8),
                                      widget.todo!.audioBase64!.isEmpty
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
                                  TextRegular(
                                      "When: ${AppDateUtil.formatDate(widget.todo!.todoDate!)}",
                                      fontSize: 14,
                                      fontColor: CustomColors.grey),
                                  const SizedBox(height: 8),
                                  if (widget.todo!.location!.isNotEmpty)
                                    TextRegular(
                                        "Where: ${widget.todo!.location}",
                                        fontSize: 14,
                                        fontColor: CustomColors.grey),
                                ])),
                        Icon(Icons.check_box),
                      ])
                    ])))));
  }
}
