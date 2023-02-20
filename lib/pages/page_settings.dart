import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jog_dog/widgets/theme_selector.dart';

import '../utilities/debugLogger.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
              const ThemeSelector(),
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
