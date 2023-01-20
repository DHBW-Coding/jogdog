import 'package:flutter/material.dart';
import 'package:jog_dog/pages/page_history.dart';
import 'package:jog_dog/pages/page_home.dart';
import 'package:jog_dog/pages/page_settings.dart';
import 'package:jog_dog/theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: Scaffold(
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentPageIndex,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.house_outlined), label: "Home"),
              NavigationDestination(
                  icon: Icon(Icons.history), label: "History"),
              NavigationDestination(
                  icon: Icon(Icons.settings), label: 'Settings')
            ],
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
          ),
          body: <Widget>[
            const Home(
              title: 'Home',
            ),
            const History(),
            const Settings()
          ][currentPageIndex],
        ));
  }
}
