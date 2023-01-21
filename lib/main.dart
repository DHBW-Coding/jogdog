import 'package:flutter/material.dart';
import 'package:jog_dog/pages/page_history.dart';
import 'package:jog_dog/pages/page_home.dart';
import 'package:jog_dog/theme/theme.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
  requestPermissions();
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


Future<bool> requestPermissions() async {

  PermissionStatus currentStatus;
  Map<Permission, PermissionStatus> allPermissionsStatus;

  if (await Permission.location.serviceStatus.isEnabled){
    currentStatus = await Permission.location.status;

    if(currentStatus.isGranted){
      print("Permission is already granted");
      return true;

    }else if(currentStatus.isDenied){
      allPermissionsStatus = await [
        Permission.location,
      ].request();
      print("Permission granted");
      return true;

    }else if(currentStatus.isPermanentlyDenied){
      print("Status is permanently denied please change in settings Page");
      openAppSettings();
      return true; // TODO: It is not guaranteed that the use will change the settings!
    }

  }else{
    print("Error no Location Service");
    return false;
  }

  return false;
}