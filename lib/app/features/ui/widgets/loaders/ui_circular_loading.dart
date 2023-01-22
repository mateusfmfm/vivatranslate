import 'package:flutter/material.dart';
import 'package:vivatranslate_mateus/app/core/theme/colors/app_colors.dart';

class UICircularLoading extends StatelessWidget {
  const UICircularLoading({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
            color: color ?? CustomColors.primaryBlue, strokeWidth: 2.25));
  }
}
