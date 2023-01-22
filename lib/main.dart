import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jog_dog/pages/page_home.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:jog_dog/pages/page_history.dart';
import 'package:jog_dog/theme/theme.dart';
import 'package:jog_dog/utilities/debugLogger.dart';


var logger;

void main() {
  runApp(MyApp());
  requestPermissions();

  // If in Debug Mode this Code will be executed 
  // Else this code will be removed automatically
  if(kDebugMode){
    logger = allLogger;
    //dataLogger = DebugLogger().data;
  }else{
    logger = null;
    //dataLogger = null;
  }

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
      child: Home(title: "Home")
    ),
    const Center(
      child: LogWidgetContainer(),
      //child: History(),
    ),
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
            BottomNavigationBarItem(icon: Icon(Icons.house_outlined), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
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
      if(kDebugMode) { logger.i("Permission is already granted"); }
      return true;

    }else if(currentStatus.isDenied){
      allPermissionsStatus = await [
        Permission.location,
      ].request();
      if(kDebugMode) { logger.i("Permission granted"); }
      return true;

    }else if(currentStatus.isPermanentlyDenied){
      if(kDebugMode) { logger.i("Status is permanently denied please change in settings Page"); }
      openAppSettings();
      return true; // TODO: It is not guaranteed that the user will change the settings!
    }

  }else{
    if(kDebugMode) { logger.e("No Location Service Found!"); }
    return false;
  }

  if(kDebugMode) { logger.e("Error! This could should be not reachable"); }
  return false;
}