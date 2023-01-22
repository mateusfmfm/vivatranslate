// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:vivatranslate_mateus/app/core/theme/colors/app_colors.dart';

class UIFloatingActionButton extends StatefulWidget {
  const UIFloatingActionButton({
    Key? key,
    required this.onPressed,
    this.icon,
  }) : super(key: key);

  final Function()? onPressed;
  final Widget? icon;

  @override
  State<UIFloatingActionButton> createState() => _UIFloatingActionButtonState();
}

class _UIFloatingActionButtonState extends State<UIFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: widget.onPressed!,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: CustomColors.gradient,
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: widget.icon,
        ),
      ),
    );
  }
}
