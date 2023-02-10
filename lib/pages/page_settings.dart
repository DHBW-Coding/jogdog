import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/debugLogger.dart';

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
              onPressed: () {}, child: const Text('Request Permission')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) =>  const LogWidgetContainer())));
              } ,child: const Text('Open Logger')),
        ])));
  }
}
