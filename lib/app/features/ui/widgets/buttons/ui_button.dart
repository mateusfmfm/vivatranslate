import 'package:flutter/material.dart';
import 'package:vivatranslate_mateus/app/core/theme/colors/app_colors.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/texts/custom_text.dart';

class UIButton extends StatefulWidget {
  const UIButton(
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
      this.buttonHeight,
      this.secondary = false})
      : super(key: key);

  final String? label;
  final String? preffixIcon;
  final bool? rounded;
  final Color? color;
  final Color? borderColor;
  final Color? fontColor;
  final void Function()? onPressed;
  final bool? isLoading;
  final bool? secondary;
  final double? fontSize;
  final double? buttonWidth;
  final double? buttonHeight;

  @override
  State<UIButton> createState() => _UIButtonState();
}

class _UIButtonState extends State<UIButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: MaterialButton(
        onPressed: widget.onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: const EdgeInsets.all(0.0),
        child: Ink(
          decoration: const BoxDecoration(
            gradient: CustomColors.gradient,
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                color: widget.secondary! ? Theme.of(context).backgroundColor : null,
              ),
              alignment: Alignment.center,
              child: TextMedium(widget.label, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}
