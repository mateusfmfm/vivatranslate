import 'dart:math';

class IDUtil {
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String get getId => String.fromCharCodes(Iterable.generate(
      18, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
