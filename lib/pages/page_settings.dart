import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jog_dog/widgets/theme_selector.dart';
import 'package:jog_dog/widgets/tolerance_selector.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
              Text("Display", style: Theme.of(context).textTheme.headlineSmall),
              Card(
                child: Column(
                  children: const [
                    ThemeSelector(),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text("General", style: Theme.of(context).textTheme.headlineSmall),
              Card(
                child: Column(
                  children: [
                    const ToleranceSelector(),
                    ListTile(
                      title: const Text("Clear all data"),
                      leading: const Icon(Icons.delete_forever_outlined),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text("Support", style: Theme.of(context).textTheme.headlineSmall),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Get in touch"),
                      leading: const Icon(Icons.mail_outline),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        launchUrlString(
                            "mailto:ExampleMail@gmail.com?subject=Support%20Jog%20Dog&body=Hi%20there!");
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Tip us a coffee"),
                      leading: const Icon(Icons.attach_money_outlined),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        launchUrlString("https://www.paypal.me/jberger18", mode: LaunchMode.externalApplication);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              if(kDebugMode)
                Text("Development", style: Theme.of(context).textTheme.headlineSmall),
              if (kDebugMode)
                Card(
                  child: ListTile(
                    title: const Text("Show debug console"),
                    leading: const Icon(Icons.announcement_outlined),
                    onTap: () {
                      setState(
                        () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const LogWidgetContainer()));
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
