import 'dart:convert';

class LevelSubStep {
  final String name;
  final String details;
  final String description;

  LevelSubStep({
    required this.name,
    required this.details,
    required this.description,
  });

  factory LevelSubStep.fromJson(Map<String, dynamic> json) {
    return LevelSubStep(
      name: json['name'],
      details: json['details'],
      description: json['description'],
    );
  }
}

class LevelStep {
  final String name;
  final List<LevelSubStep> steps;

  LevelStep({
    required this.name,
    required this.steps,
  });

  factory LevelStep.fromJson(Map<String, dynamic> json) {
    var stepsList = json['steps'] as List;
    List<LevelSubStep> steps = stepsList.map((i) => LevelSubStep.fromJson(i)).toList();

    return LevelStep(
      name: json['name'],
      steps: steps,
    );
  }
}

class Level {
  final String name;
  final List<LevelStep> steps;

  Level({
    required this.name,
    required this.steps,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    var stepsList = json['steps'] as List;
    List<LevelStep> steps = stepsList.map((i) => LevelStep.fromJson(i)).toList();

    return Level(
      name: json['name'],
      steps: steps,
    );
  }
}

class LevelSkeleton {
  final List<Level> levels;

  LevelSkeleton({required this.levels});
}

class SkeletonParser {
  static LevelSkeleton parseJson(String json) {
    final List parsedJson = jsonDecode(json);
    return LevelSkeleton(
      levels: parsedJson.map((json) => Level.fromJson(json)).toList(),
    );
  }
}
