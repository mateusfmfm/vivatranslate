import 'package:flutter/material.dart';
import 'package:vivatranslate_mateus/app/core/theme/colors/app_colors.dart';
import 'package:vivatranslate_mateus/app/core/theme/fonts/roboto_style.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/texts/custom_text.dart';

class UITextField extends StatefulWidget {
  const UITextField({
    Key? key,
    this.suffixIcon,
    this.preffixIcon,
    this.onTap,
    this.onChanged,
    this.hintText,
    this.square = false,
    this.obscureText = false,
    this.controller,
    this.initialValue,
    this.datePicker = false,
    this.errorText = "",
    this.validator,
  }) : super(key: key);

  final Widget? preffixIcon;
  final Widget? suffixIcon;
  final Function()? onTap;
  final Function(String)? onChanged;
  final String? hintText;
  final bool? square;
  final bool? obscureText;
  final TextEditingController? controller;
  final String? initialValue;
  final bool? datePicker;
  final String? errorText;
  final String? Function(String?)? validator;

  @override
  State<UITextField> createState() => _UITextFieldState();
}

class _UITextFieldState extends State<UITextField> {
  var fieldFocused = false;
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);
    final border = OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: fieldFocused ? Colors.transparent : CustomColors.lightGrey,
        ));
    final errorBorder = OutlineInputBorder(
        borderRadius: borderRadius, borderSide: BorderSide(color: Colors.red));
    return FocusScope(
      onFocusChange: (value) => setState(() {
        fieldFocused = value;
      }),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.hintText != null) TextMedium(widget.hintText),
            if (widget.hintText != null) const SizedBox(height: 8),
            GestureDetector(
              onTap: widget.datePicker! ? widget.onTap : null,
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    gradient: fieldFocused ? CustomColors.gradient : null,
                    borderRadius: borderRadius),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextFormField(
                    validator: widget.validator,
                    enabled: !widget.datePicker!,
                    obscureText: widget.obscureText!,
                    onChanged: widget.onChanged,
                    controller: widget.controller,
                    initialValue: widget.initialValue,
                    style: RobotoStyle.regular(context).merge(TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 16)),
                    cursorColor: CustomColors.primaryBlue,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).backgroundColor,
                        focusedBorder: border,
                        enabledBorder: border,
                        errorBorder: errorBorder,
                        disabledBorder: border,
                        suffixIcon: widget.suffixIcon,
                        prefixIconColor: CustomColors.lightGrey,
                        prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: widget.preffixIcon)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
