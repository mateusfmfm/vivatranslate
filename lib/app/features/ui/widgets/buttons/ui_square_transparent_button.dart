import 'package:flutter/material.dart';
import 'package:vivatranslate_mateus/app/core/theme/colors/app_colors.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/texts/custom_text.dart';

class UISquareTransparentButton extends StatefulWidget {
  const UISquareTransparentButton(
      {Key? key,
      @required this.isLoading,
      @required this.label,
      @required this.onPressed,
      this.rounded = false,
      this.preffixIcon = "",
      this.color,
      this.borderColor,
      this.fontColor,
      this.fontSize,
      this.buttonWidth,
      this.buttonHeight})
      : super(key: key);

  final String? label;
  final String? preffixIcon;
  final bool? rounded;
  final Color? color;
  final Color? borderColor;
  final Color? fontColor;
  final void Function()? onPressed;
  final bool? isLoading;
  final double? fontSize;
  final double? buttonWidth;
  final double? buttonHeight;

  @override
  State<UISquareTransparentButton> createState() => _UISquareTransparentButtonState();
}

class _UISquareTransparentButtonState extends State<UISquareTransparentButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      child: Ink(
        decoration: const BoxDecoration(
          gradient: CustomColors.gradient,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              color: Theme.of(context).backgroundColor,
            ),
            alignment: Alignment.center,
            child: Center(child: TextMedium(widget.label, textAlign: TextAlign.center)),
          ),
        ),
      ),
    );
  }
}
