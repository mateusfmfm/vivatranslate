import 'package:flutter/material.dart';
import 'package:vivatranslate_mateus/app/core/theme/fonts/roboto_style.dart';

class TextSpanThin extends TextSpan {
  final BuildContext? context;
  final String content;
  final Color? color;
  final double fontSize;
  final FontStyle fontStyle;

  const TextSpanThin(this.content, {this.context, this.fontSize = 14, this.color, this.fontStyle = FontStyle.normal})
      : super(text: content);

  @override
  TextStyle get style => RobotoStyle.thin(context!).merge(TextStyle(
      fontSize: fontSize, color: color ?? Theme.of(context!).textTheme.bodyText1!.color, fontStyle: fontStyle));
}

class TextSpanLight extends TextSpan {
  final BuildContext? context;
  final String content;
  final Color? color;
  final double fontSize;
  final FontStyle fontStyle;

  const TextSpanLight(this.content, {this.context, this.fontSize = 14, this.color, this.fontStyle = FontStyle.normal})
      : super(text: content);

  @override
  TextStyle get style => RobotoStyle.light(context!).merge(TextStyle(
      fontSize: fontSize, color: color ?? Theme.of(context!).textTheme.bodyText1!.color, fontStyle: fontStyle));
}

class TextSpanRegular extends TextSpan {
  final BuildContext? context;
  final String content;
  final Color? color;
  final double fontSize;
  final FontStyle fontStyle;

  const TextSpanRegular(this.content, {this.context, this.fontSize = 14, this.color, this.fontStyle = FontStyle.normal})
      : super(text: content);

  @override
  TextStyle get style => RobotoStyle.regular(context!).merge(TextStyle(
      fontSize: fontSize, color: color ?? Theme.of(context!).textTheme.bodyText1!.color, fontStyle: fontStyle));
}

class TextSpanMedium extends TextSpan {
  final BuildContext? context;
  final String content;
  final Color? color;
  final double fontSize;
  final FontStyle fontStyle;

  const TextSpanMedium(this.content, {this.context, this.fontSize = 14, this.color, this.fontStyle = FontStyle.normal})
      : super(text: content);

  @override
  TextStyle get style => RobotoStyle.medium(context!).merge(TextStyle(
      fontSize: fontSize,
      height: 1.5,
      color: color ?? Theme.of(context!).textTheme.bodyText1!.color,
      fontStyle: fontStyle));
}

class TextSpanBold extends TextSpan {
  final BuildContext? context;
  final String content;
  final Color? color;
  final double fontSize;
  final FontStyle fontStyle;

  const TextSpanBold(this.content, {this.context, this.fontSize = 14, this.color, this.fontStyle = FontStyle.normal})
      : super(text: content);

  @override
  TextStyle get style => RobotoStyle.bold(context!).merge(TextStyle(
      fontSize: fontSize,
      height: 1.5,
      color: color ?? Theme.of(context!).textTheme.bodyText1!.color,
      fontStyle: fontStyle));
}
