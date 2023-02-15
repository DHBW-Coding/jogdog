import 'package:flutter/material.dart';

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
          title: const Text('Settings'),
        ),
        body: Center(
            child: Column(children: [
          const Text('Permissions:'),
          const Text('To start the app you have to accept these permissions.'),
          ElevatedButton(
              onPressed: () {}, child: const Text('Request Permission'))
        ])));
  }
}
