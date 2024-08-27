import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_archery/experience_levels/skeleton_parser.dart';
import 'package:my_archery/experience_levels/widget_generator.dart';
import 'package:my_archery/storage.dart';

late final LevelSkeleton levelSkeleton;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  levelSkeleton = SkeletonParser.parseJson(await rootBundle.loadString("assets/skeleton.json"));
  Storage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Archery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Archery"),
      ),
      body: WidgetGenerator(skeleton: levelSkeleton),
    );
  }
}
