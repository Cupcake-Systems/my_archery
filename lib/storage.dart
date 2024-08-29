import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_archery/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static double getLevelSubStepRating(String levelName, String stepName, String subStepName) {
    return _prefs.getDouble("$levelName/$stepName/$subStepName") ?? 1;
  }

  static Iterable<double> getLevelSubStepRatings(String levelName, String stepName) sync* {
    final subSteps = levelSkeleton.levels.firstWhere((e) => e.name == levelName).steps.firstWhere((e) => e.name == stepName).steps;
    for (final subStep in subSteps) {
      yield getLevelSubStepRating(levelName, stepName, subStep.name);
    }
  }

  static void setLevelSubStepRating(String levelName, String stepName, String subStepName, double rating) {
    _prefs.setDouble("$levelName/$stepName/$subStepName", rating);
  }

  static void setMainColor(Color color) {
    _prefs.setString("main color", color.toHexString());
  }

  static Color? getMainColor() {
    final setHex = _prefs.getString("main color");
    if (setHex == null) return null;
    return Color(int.parse(setHex, radix: 16));
  }

  static void setTheme(ThemeMode theme) {
    _prefs.setString("theme", theme.name);
  }

  static ThemeMode getTheme() {
    final t = _prefs.getString("theme");
    if (t == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere((e) => e.name == t) ;
  }
}
