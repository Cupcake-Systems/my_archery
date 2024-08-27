import 'package:flutter/material.dart';
import 'package:my_archery/main.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            const Text(
              'Entwickler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text("Finn Drünert"),
              trailing: ElevatedButton.icon(
                onPressed: () {
                  launchUrlString("https://finn.druenert.com");
                },
                label: const Text("Website"),
                icon: const Icon(Icons.link),
              ),
            ),
            const Spacer(),
            Center(
              child: Text(
                'App Version ${packageInfo.version} Build ${packageInfo.buildNumber}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
