// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vivatranslate_mateus/app/core/theme/cubit/theme_cubit.dart';
import 'package:vivatranslate_mateus/app/features/routes/app_routes.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/buttons/ui_floating_action_button.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/loaders/ui_circular_loading.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/scaffolds/widgets/action_buttons.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/texts/custom_text.dart';

class UIScaffold extends StatefulWidget {
  const UIScaffold({
    super.key,
    required this.body,
    this.title,
    this.subtitle,
    this.scrollPhysics,
    this.isPageLoading = false,
    this.bottomNavIndex,
    this.bottomWidget,
  });

  final List<Widget>? body;
  final String? title;
  final String? subtitle;
  final ScrollPhysics? scrollPhysics;
  final bool? isPageLoading;
  final int? bottomNavIndex;
  final Widget? bottomWidget;

  @override
  State<UIScaffold> createState() => _UIScaffoldState();
}

class _UIScaffoldState extends State<UIScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeCubit theme = BlocProvider.of<ThemeCubit>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 55),
        child: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          flexibleSpace: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(Routes.HOME),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 56, vertical: 10.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/logo.png"),
                      const SizedBox(width: 8),
                      const TextMedium("Viva"),
                    ])),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AspectRatio(
                  aspectRatio: .9,
                  child: Image.asset("assets/images/brazil.png")),
            ),
          ],
        ),
      ),
      drawer: const ActionButtons(),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: widget.isPageLoading!
            ? Center(
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 72.0),
                  child: UICircularLoading(),
                ),
              )
            : SafeArea(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 72.0, top: 16.0),
                      child: SizedBox(
                        child: ListView(
                            physics: widget.scrollPhysics ??
                                const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            children: widget.body!),
                      ),
                    )),
              ),
      ),
      floatingActionButton: UIFloatingActionButton(
        onPressed: () => theme.changeTheme(),
        icon: Icon(theme.isDark ? Icons.light_mode : Icons.dark_mode),
      ),
    );
  }
}
