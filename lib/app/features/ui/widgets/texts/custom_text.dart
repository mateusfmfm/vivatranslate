import 'package:flutter/material.dart';
import 'package:vivatranslate_mateus/app/core/theme/fonts/roboto_style.dart';

class TextRegular extends StatelessWidget {
  const TextRegular(this.text,
      {this.onTap,
      this.fontSize = 16,
      this.fontColor,
      this.fontStyle,
      this.underline = false,
      Key? key,
      this.textAlign,
      this.foreground})
      : super(key: key);

  final Function()? onTap;
  final String? text;
  final double? fontSize;
  final Color? fontColor;
  final FontStyle? fontStyle;
  final bool? underline;
  final TextAlign? textAlign;
  final Paint? foreground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Text(text!,
            textAlign: textAlign ?? TextAlign.left,
            style: RobotoStyle.regular(context).merge(TextStyle(
                color: fontColor ?? Theme.of(context).textTheme.bodyText1!.color,
                fontSize: fontSize,
                foreground: foreground,
                fontStyle: fontStyle ?? FontStyle.normal,
                decoration: underline! ? TextDecoration.underline : TextDecoration.none))));
  }
}

class TextLight extends StatelessWidget {
  const TextLight(this.text,
      {this.onTap,
      this.fontSize = 16,
      this.fontColor,
      this.fontStyle,
      this.underline = false,
      Key? key,
      this.textAlign,
      this.foreground})
      : super(key: key);

  final Function()? onTap;
  final String? text;
  final double? fontSize;
  final Color? fontColor;
  final FontStyle? fontStyle;
  final bool? underline;
  final TextAlign? textAlign;
  final Paint? foreground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Text(text!,
            textAlign: textAlign ?? TextAlign.left,
            style: RobotoStyle.light(context).merge(TextStyle(
                color: fontColor ?? Theme.of(context).textTheme.bodyText1!.color,
                fontSize: fontSize,
                foreground: foreground,
                fontStyle: fontStyle ?? FontStyle.normal,
                decoration: underline! ? TextDecoration.underline : TextDecoration.none))));
  }
}

class TextThin extends StatelessWidget {
  const TextThin(this.text,
      {this.onTap,
      this.fontSize = 16,
      this.fontColor,
      this.fontStyle,
      this.underline = false,
      Key? key,
      this.textAlign,
      this.foreground})
      : super(key: key);

  final Function()? onTap;
  final String? text;
  final double? fontSize;
  final Color? fontColor;
  final FontStyle? fontStyle;
  final bool? underline;
  final TextAlign? textAlign;
  final Paint? foreground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Text(text!,
            textAlign: textAlign ?? TextAlign.left,
            style: RobotoStyle.thin(context).merge(TextStyle(
                color: fontColor ?? Theme.of(context).textTheme.bodyText1!.color,
                fontSize: fontSize,
                foreground: foreground,
                fontStyle: fontStyle ?? FontStyle.normal,
                decoration: underline! ? TextDecoration.underline : TextDecoration.none))));
  }
}

class TextMedium extends StatelessWidget {
  const TextMedium(this.text,
      {this.onTap,
      this.fontSize = 16,
      this.fontColor,
      this.fontStyle,
      this.underline = false,
      Key? key,
      this.textAlign,
      this.foreground})
      : super(key: key);

  final Function()? onTap;
  final String? text;
  final double? fontSize;
  final Color? fontColor;
  final FontStyle? fontStyle;
  final bool? underline;
  final TextAlign? textAlign;
  final Paint? foreground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Text(text!,
            textAlign: textAlign ?? TextAlign.left,
            style: RobotoStyle.medium(context).merge(TextStyle(
                color: fontColor ?? Theme.of(context).textTheme.bodyText1!.color,
                fontSize: fontSize,
                foreground: foreground,
                fontStyle: fontStyle ?? FontStyle.normal,
                decoration: underline! ? TextDecoration.underline : TextDecoration.none))));
  }
}

class TextBold extends StatelessWidget {
  const TextBold(this.text,
      {this.onTap,
      this.fontSize = 16,
      this.fontColor,
      this.fontStyle,
      this.underline = false,
      Key? key,
      this.textAlign,
      this.foreground})
      : super(key: key);

  final Function()? onTap;
  final String? text;
  final double? fontSize;
  final Color? fontColor;
  final FontStyle? fontStyle;
  final bool? underline;
  final TextAlign? textAlign;
  final Paint? foreground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Text(text!,
            textAlign: textAlign ?? TextAlign.left,
            style: RobotoStyle.bold(context).merge(TextStyle(
                color: fontColor ?? Theme.of(context).textTheme.bodyText1!.color,
                fontSize: fontSize,
                foreground: foreground,
                fontStyle: fontStyle ?? FontStyle.normal,
                decoration: underline! ? TextDecoration.underline : TextDecoration.none))));
  }
}
