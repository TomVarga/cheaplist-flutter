import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColorLight: const Color(0xffffad42),
  accentColor: const Color(0xff6d4c41),
  primaryColorDark: const Color(0xffbb4d00),
  secondaryHeaderColor: const Color(0xff6d4c41),
);

class AppColors {
  static Color lightTextColor = Colors.white;
  static Color fadedTextColor = Colors.grey[300];
}

ThemeData theme(context) {
  ThemeData themeData =
  defaultTargetPlatform == TargetPlatform.iOS ? kIOSTheme : kDefaultTheme;
  return themeData;
}

String getAppBarHeroTag() {
  return "appBarTag";
}

String getAppName() {
  return 'CheapList';
}
