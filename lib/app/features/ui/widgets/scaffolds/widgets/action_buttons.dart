import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivatranslate_mateus/app/core/constants/app_strings.dart';
import 'package:vivatranslate_mateus/app/features/routes/app_routes.dart';
import 'package:vivatranslate_mateus/app/features/ui/home/presentation/cubit/home_cubit.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/buttons/ui_square_transparent_button.dart';

class ActionButtons extends StatefulWidget {
  const ActionButtons({super.key});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  @override
  Widget build(BuildContext context) {
    HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context, listen: true);
    return Material(
      color: Theme.of(context).backgroundColor,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              UISquareTransparentButton(
                  isLoading: false,
                  label: AppStrings.ADD_TODO,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.ADD_TODOS)),
              const SizedBox(height: 32),
              UISquareTransparentButton(
                  isLoading: false,
                  label: AppStrings.SHOW_TODOS,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.SHOW_TODOS)),
              const SizedBox(height: 32),
              UISquareTransparentButton(
                  isLoading: false,
                  label: AppStrings.FINISHED_TODOS,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.FINISHED_TODOS)),
            ]),
          )),
    );
  }
}
