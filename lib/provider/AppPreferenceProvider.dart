// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference extends ChangeNotifier {
  static const String _allowAutoPrintKey = 'is_auto_print';

  late bool _is_auto_print;

  bool get is_auto_print => _is_auto_print;

  Future<void> fetchSettings() async {
    var prefs = await SharedPreferences.getInstance();

    _is_auto_print = prefs.getString(_allowAutoPrintKey) == null
        ? true
        : int.parse(prefs.getString(_allowAutoPrintKey) ?? "0") == 1
            ? true
            : false;
  }

  Future<void> changeAutoPrintPreference(bool val) async {
    if (kDebugMode) {
      print("change autoprint" + val.toString());
    }

    var prefs = await SharedPreferences.getInstance();

    if (val == true) {
      await prefs.setString(_allowAutoPrintKey, '1');
    } else {
      await prefs.setString(_allowAutoPrintKey, '0');
    }
    await fetchSettings();

    if (kDebugMode) {
      print("autoprint changed" + _is_auto_print.toString());
    }
    notifyListeners();
  }
}
