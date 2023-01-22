import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
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

class _AddTodoFormState extends State<AddTodoForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  AnimationController? _controller;
  Animation<double>? _animation;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController whereController = TextEditingController();

  int _recordDuration = 0;
  Timer? _timer;
  final _audioRecorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  final record = Record();
  String appDocPath = "";
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn);

    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });
    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) => setState(() => _amplitude = amp));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      appDocPath = '${appDocDir.path}/viva/';
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
        if (state is AddTodoFormShow) _controller!.forward();
        if (state is AddTodoFormHide) _controller!.reverse();
        if (state is HideAll) _controller!.reverse();
      },
      child: Form(
        key: _formKey,
        child: SizeTransition(
          sizeFactor: _controller!,
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
      ),
    );
  }

  _startRecord() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.flac,
        );
        if (kDebugMode) {
          print('${AudioEncoder.flac.name} supported: $isSupported');
        }
        String endFile = ".wav";
        String pathTo = appDocPath + DateTime.now().toString() + endFile;
        await _audioRecorder.start(
          path: pathTo,
          samplingRate: 16000,
          numChannels: 1,
        );
        _recordDuration = 0;
        isRecording = await _audioRecorder.isRecording();
        setState(() {});
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  _stopRecord() async {
    _timer?.cancel();
    _recordDuration = 0;

    var finalPath = await _audioRecorder.stop();
    isRecording = await _audioRecorder.isRecording();

    await BlocProvider.of<HomeCubit>(context).transcribeDescription(finalPath!);

    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }
}
