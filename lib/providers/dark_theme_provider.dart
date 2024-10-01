import 'package:artisthub/services/dark_theme_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//for theme
class DarkThemeProvider with ChangeNotifier{
  DarkThemePrefs darkThemePrefs =DarkThemePrefs();
  bool _darkTheme = false;
  bool get getDarkTheme => _darkTheme;

  set setDarkTheme(bool value){

    _darkTheme = value;
    darkThemePrefs.setDarkTheme(value);
    notifyListeners();

  }

}