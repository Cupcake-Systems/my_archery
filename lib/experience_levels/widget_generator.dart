import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:my_archery/experience_levels/skeleton_parser.dart';
import 'package:my_archery/main.dart';
import 'package:my_archery/storage.dart';

class WidgetGenerator extends StatelessWidget {
  final LevelSkeleton skeleton;

  const WidgetGenerator({super.key, required this.skeleton});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final level in skeleton.levels) ...[
          LevelWidget(level: level),
        ],
      ],
    );
  }
}

class LevelWidget extends StatefulWidget {
  final Level level;

  const LevelWidget({super.key, required this.level});

  @override
  State<LevelWidget> createState() => _LevelWidgetState();
}

class _LevelWidgetState extends State<LevelWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          childrenPadding: const EdgeInsets.all(8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.level.name),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi),
                child: RatingStars(
                  value: getLevelScore(widget.level.name),
                  valueLabelVisibility: false,
                  starColor: Theme.of(context).colorScheme.primary,
                  starOffColor: Colors.transparent,
                ),
              ),
            ],
          ),
          children: [
            for (final step in widget.level.steps) ...[
              LevelStepWidget(
                step: step,
                level: widget.level,
                scoreUpdate: () => setState(() {}),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class LevelStepWidget extends StatefulWidget {
  final Level level;
  final LevelStep step;
  final void Function() scoreUpdate;

  const LevelStepWidget({
    super.key,
    required this.step,
    required this.level,
    required this.scoreUpdate,
  });

  @override
  State<LevelStepWidget> createState() => _LevelStepWidgetState();
}

class _LevelStepWidgetState extends State<LevelStepWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
        elevation: WidgetStatePropertyAll(1.5),
      ),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Builder(builder: (context) {
                return Scaffold(
                  appBar: AppBar(title: Text(widget.step.name)),
                  body: ListView(
                    children: [
                      for (final subStep in widget.step.steps) ...[
                        LevelSubStepWidget(
                          subStep: subStep,
                          level: widget.level,
                          levelStep: widget.step,
                        ),
                      ],
                    ],
                  ),
                );
              });
            },
          ),
        );
        widget.scoreUpdate();
      },
      child: ListTile(
        title: Text(widget.step.name),
        trailing: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: RatingStars(
            valueLabelVisibility: false,
            value: getLevelStepScore(widget.level.name, widget.step.name),
            starColor: Theme.of(context).colorScheme.inversePrimary,
            starOffColor: Colors.transparent,
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

class LevelSubStepWidget extends StatefulWidget {
  final Level level;
  final LevelStep levelStep;
  final LevelSubStep subStep;

  const LevelSubStepWidget({super.key, required this.subStep, required this.level, required this.levelStep});

  @override
  State<LevelSubStepWidget> createState() => _LevelSubStepWidgetState();
}

class _LevelSubStepWidgetState extends State<LevelSubStepWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.subStep.name),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              RatingStars(
                valueLabelVisibility: false,
                onValueChanged: (value) {
                  setState(() {
                    Storage.setLevelSubStepRating(widget.level.name, widget.levelStep.name, widget.subStep.name, value);
                  });
                },
                value: Storage.getLevelSubStepRating(widget.level.name, widget.levelStep.name, widget.subStep.name),
              ),
              const SizedBox(height: 10),
              Text(widget.subStep.description),
            ],
          ),
          childrenPadding: const EdgeInsets.all(8),
          children: [Text(widget.subStep.details)],
        ),
      ),
    );
  }
}

double getLevelScore(String levelName) {
  final levelSteps = levelSkeleton.levels.firstWhere((e) => e.name == levelName).steps;
  double totalScore = 0;
  for (final levelStep in levelSteps) {
    totalScore += getLevelStepScore(levelName, levelStep.name);
  }
  return totalScore / levelSteps.length;
}

double getLevelStepScore(String levelName, String stepName) {
  final ratings = Storage.getLevelSubStepRatings(levelName, stepName);
  return ratings.reduce((a, b) => a + b) / ratings.length;
}
