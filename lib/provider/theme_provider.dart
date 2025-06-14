import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../mixin/constants.dart';
import '../mixin/mixins.dart';
import '../theme/theme_data_style.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeData _themeDataStyle = ThemeDataStyle.lighter;

  ThemeData get themeDataStyle => _themeDataStyle;

  set themeDataStyle (ThemeData themeData) {
    _themeDataStyle = themeData;
    notifyListeners();
  }

  void changeTheme() {
    if (_themeDataStyle == ThemeDataStyle.light) {
      themeDataStyle = ThemeDataStyle.darker;
    } else {
      themeDataStyle = ThemeDataStyle.lighter;
    }
  }

}