import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:record/record.dart';
import 'package:vivatranslate_mateus/app/core/helpers/app_persmissions.dart';
import 'package:vivatranslate_mateus/app/core/helpers/id_util.dart';
import 'package:vivatranslate_mateus/app/features/routes/app_routes.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/data/todo_model.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/cubit/home_cubit.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/buttons/ui_button.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/loaders/ui_circular_loading.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/scaffolds/ui_scaffold.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/textfields/ui_textfield.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/texts/custom_text.dart';

class AddTodosScreen extends StatefulWidget {
  const AddTodosScreen({super.key});

  @override
  State<AddTodosScreen> createState() => _AddTodosScreenState();
}

class _AddTodosScreenState extends State<AddTodosScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController whereController = TextEditingController();
  TextEditingController whenController = TextEditingController();
  DateTime? datePicked = DateTime.now();
  String? audioBase64 = "";
  bool descriptionTyped = false;
  bool canContinue = true;

  final _audioRecorder = Record();

  String appDocPath = "";
  bool isRecording = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await AppPermissions().getPermissions();
      Directory appDocDir = await getApplicationDocumentsDirectory();
      appDocPath = '${appDocDir.path}\\viva\\'.replaceAll("\\", "/");
      Directory(appDocPath).create();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is PerformingAddTodoSuccess)
            Navigator.of(context).pushNamed(Routes.SHOW_TODOS);
          if (state is TranscriptionSuccessful) {
            setState(() {
              descriptionTyped = false;
              descriptionController.text = "";
              descriptionController.text = state.result!;
            });
          }
          ;
        },
        child: UIScaffold(title: "Add ToDo", body: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                      validator: (value) {
                        if (value == null || value.isEmpty) return;
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
                                ? const Icon(Icons.pause, color: Colors.red)
                                : const Icon(Icons.mic),
                      ),
                    );
                  },
                ),
                UITextField(
                  hintText: "Where?",
                  controller: whereController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return;
                  },
                ),
                UITextField(
                  hintText: "When?",
                  onTap: () async => await _getDate(),
                  controller: whenController,
                  datePicker: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return;
                  },
                ),
                const SizedBox(height: 24),
                if (!canContinue)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextMedium("Complete all fields.",
                          fontColor: Colors.red),
                    ),
                  ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    final bloc = context.read<HomeCubit>();
                    return Row(
                      children: [
                        Flexible(
                            flex: 1,
                            child: UIButton(
                                label: "Save",
                                isLoading: false,
                                onPressed: (state is TranscriptionInitialized)
                                    ? null
                                    : () async {
                                        if (!_validateFields()) {
                                          return;
                                        } else {
                                          await bloc.performAddTodo(Todo(
                                              id: IDUtil().getId,
                                              description:
                                                  descriptionController.text,
                                              location: whereController.text,
                                              todoDate: datePicked,
                                              isCompleted: false,
                                              audioBase64: descriptionTyped
                                                  ? ""
                                                  : audioBase64!,
                                              createdAt: DateTime.now()));
                                        }
                                      })),
                        const SizedBox(width: 16),
                        Flexible(
                            flex: 1,
                            child: UIButton(
                              label: "Cancel",
                              isLoading: false,
                              secondary: true,
                              onPressed: (state is TranscriptionInitialized)
                                  ? null
                                  : () => Navigator.of(context).pop(),
                            ))
                      ],
                    );
                  },
                )
              ]),
            ),
          ),
        ]));
  }

  bool _validateFields() {
    setState(() {
      canContinue = (descriptionController.text.isNotEmpty ||
          whereController.text.isNotEmpty ||
          whenController.text.isNotEmpty);
    });
    return canContinue;
  }

  Future<void> _getDate() async {
    datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
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
    final path = await _audioRecorder.stop();
    final finalPath = path!.replaceAll("\\", "/");
    isRecording = await _audioRecorder.isRecording();
    audioBase64 = base64Encode(await File(finalPath).readAsBytes());
    log(finalPath);
    setState(() {});
    await BlocProvider.of<HomeCubit>(context).transcribeDescription(finalPath);
  }
}
