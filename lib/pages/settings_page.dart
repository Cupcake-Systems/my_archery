import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_archery/storage.dart';

class SettingsPage extends StatelessWidget {
  final void Function() mainColorChange;

  const SettingsPage({super.key, required this.mainColorChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Einstellungen"),
      ),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Text(
                    "Aussehen",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ListTile(
                    title: const Text("Farbe"),
                    trailing: ElevatedButton.icon(
                      icon: Icon(Icons.circle, color: Storage.getMainColor()),
                      label: const Text('Auswählen'),
                      onPressed: () {
                        Color color = Storage.getMainColor() ?? Colors.white;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Farbe auswählen'),
                            content: SingleChildScrollView(
                              child: MaterialPicker(
                                pickerColor: color,
                                onColorChanged: (value) {
                                  color = value;
                                },
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text('Fertig'),
                                onPressed: () {
                                  Storage.setMainColor(color);
                                  mainColorChange();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text("Helligkeit"),
                    trailing: DropdownMenu(
                      initialSelection: Storage.getTheme(),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: ThemeMode.light, label: "Hell"),
                        DropdownMenuEntry(value: ThemeMode.dark, label: "Dunkel"),
                        DropdownMenuEntry(value: ThemeMode.system, label: "System"),
                      ],
                      onSelected: (theme) {
                        Storage.setTheme(theme!);
                        mainColorChange();
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
