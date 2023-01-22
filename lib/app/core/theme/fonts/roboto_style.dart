import 'package:flutter/material.dart';

class RobotoStyle {
  static TextStyle thin(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w100);
  }

  static TextStyle light(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w300);
  }

  static TextStyle regular(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400);
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500);
  }

  static TextStyle bold(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1!.copyWith(
        fontSize: 14,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w700);
  }
}
