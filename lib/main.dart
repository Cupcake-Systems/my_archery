import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_archery/experience_levels/skeleton_parser.dart';
import 'package:my_archery/experience_levels/widget_generator.dart';
import 'package:my_archery/pages/about_page.dart';
import 'package:my_archery/pages/settings_page.dart';
import 'package:my_archery/storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

const String repoUrl = "https://github.com/Cupcake-Systems/my_archery";
const String reportIssueUrl = "$repoUrl/issues/new";

late final LevelSkeleton levelSkeleton;
late final PackageInfo packageInfo;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Storage.init();
  levelSkeleton = SkeletonParser.parseJson(await rootBundle.loadString("assets/skeleton.json"));
  packageInfo = await PackageInfo.fromPlatform();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Archery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Storage.getMainColor() ?? Colors.black,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Storage.getMainColor() ?? Colors.white,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: Storage.getTheme(),
      home: MyHomePage(
        mainColorUpdate: () => setState(() {}),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final void Function() mainColorUpdate;

  const MyHomePage({super.key, required this.mainColorUpdate});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Archery"),
      ),
      body: [
        WidgetGenerator(skeleton: levelSkeleton),
        const Center(child: Text("Coming soon")),
        const Center(child: Text("Coming soon")),
      ][selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(label: "Technik", icon: Icon(Icons.account_tree)),
          BottomNavigationBarItem(label: "Ausrüstung", icon: Icon(Icons.accessibility)),
          BottomNavigationBarItem(label: "Ergebnisse", icon: Icon(Icons.circle)),
        ],
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
              child: const Text('My Archery'),
            ),
            ListTile(
              title: const Text('Einstellungen'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SettingsPage(mainColorChange: widget.mainColorUpdate);
                    },
                  ),
                );
              },
              leading: const Icon(Icons.settings),
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const AboutPage();
                    },
                  ),
                );
              },
              leading: const Icon(Icons.info),
            ),
            const Spacer(),
            ListTile(
              title: const Text('GitHub Repo'),
              onTap: () => launchUrlString(repoUrl),
              leading: const Icon(Icons.build),
            ),
            ListTile(
              title: const Text('Fehler melden'),
              onTap: () => launchUrlString(reportIssueUrl),
              leading: const Icon(Icons.bug_report),
            ),
          ],
        ),
      ),
    );
  }
}
