import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:vivatranslate_mateus/app/features/routes/app_routes.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/data/todo_model.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/cubit/home_cubit.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/buttons/ui_button.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/loaders/ui_circular_loading.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/textfields/ui_textfield.dart';

class AddTodoForm extends StatefulWidget {
  const AddTodoForm({super.key});

  @override
  State<AddTodoForm> createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController whereController = TextEditingController();

  final _audioRecorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  StreamSubscription<Amplitude>? _amplitudeSub;

  String appDocPath = "";
  bool isRecording = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      appDocPath = '${appDocDir.path}\\viva\\'.replaceAll("\\", "/");
      Directory(appDocPath).create();
    });
    super.initState();
  }

  _clearFields() {
    descriptionController.text = "";
    whereController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is PerformingAddTodoSuccess) Navigator.of(context).pushNamed(Routes.SHOW_TODOS);
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return UITextField(
                  hintText: "Description",
                  controller: descriptionController,
                  suffixIcon: InkWell(
                    onTap: isRecording ? () async => await _stopRecord() : () async => await _startRecord(),
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
            ),
            const UITextField(hintText: "When?"),
            const SizedBox(height: 24),
            Row(
              children: [
                Flexible(
                    flex: 1,
                    child: UIButton(
                        label: "Save",
                        isLoading: false,
                        onPressed: () async {
                          await BlocProvider.of<HomeCubit>(context).performAddTodo(Todo(
                              description: descriptionController.text,
                              location: whereController.text,
                              createdAt: DateTime.now()));
                          _clearFields();
                        })),
                const SizedBox(width: 16),
                Flexible(
                    flex: 1,
                    child: UIButton(
                      label: "Cancel",
                      isLoading: false,
                      secondary: true,
                      onPressed: () => BlocProvider.of<HomeCubit>(context).addTodoFormHide(),
                    ))
              ],
            )
          ]),
        ),
      ),
    );
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
        String pathTo = "$appDocPath${DateTime.now()}.m4a";
        print(pathTo);
        await _audioRecorder.start(
          path: pathTo,
          samplingRate: 16000,
          numChannels: 1,
        );
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
    setState(() {});
    await BlocProvider.of<HomeCubit>(context).transcribeDescription(finalPath!);
  }

  @override
  void dispose() {
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }
}