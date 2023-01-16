import 'package:flutter/material.dart';
import 'package:jog_dog/pages/page_history.dart';
import 'package:jog_dog/pages/page_home.dart';
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
  late int index = 0;
  final pages = [
    const Center(
        child: Home(
      title: "Home",
    )),
    const Center(
      child: History(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: pages[index],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          currentIndex: index,
          selectedItemColor: Theme.of(context).accentColor,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.house_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: "History"),
          ],
          onTap: (index) => setState(() {
            this.index = index;
          }),
        ),
      ),
    );
  }
}
