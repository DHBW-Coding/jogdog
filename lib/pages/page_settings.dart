import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utilities/debugLogger.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Map<String, IconData> themes = {
    "Automatic": Icons.brightness_auto,
    "Dark Theme": Icons.brightness_3,
    "Light Theme": Icons.brightness_medium
  };

  late String _selectedTheme = "Automatic";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              Text("Display Settings",
                  style: Theme.of(context).textTheme.headlineSmall),
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                title: const Text('Select Theme'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setThemeState) => SizedBox(
                          height: themes.length * 100,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: ListView.builder(
                                itemCount: themes.length,
                                itemBuilder: (context, index) {
                                  String theme = themes.keys.elementAt(index);
                                  return RadioListTile(
                                    value: theme.toString(),
                                    groupValue: _selectedTheme,
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    secondary: Icon(themes[theme]),
                                    onChanged: (value) {
                                      setThemeState(() {
                                        _selectedTheme = value.toString();
                                      });
                                    },
                                    title: Text(
                                      theme,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  );
                                }),
                          ),
                        ),
                      );
                    },
                    enableDrag: true,
                  );
                },
              ),
              const Divider(
                color: Colors.grey,
              ),
              if (kDebugMode)
                ListTile(
                  title: const Text("Show debug console"),
                  leading: const Icon(Icons.announcement_outlined),
                  onTap: () {
                    setState(() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LogWidgetContainer()));
                    });
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
