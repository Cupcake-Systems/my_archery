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
}
