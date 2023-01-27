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
  if (kDebugMode) {
    logger = allLogger;
    //dataLogger = DebugLogger().data;
  } else {
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
    const Center(child: Home(title: "Home")),
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
  bool reqSuc = false;
  if (await Permission.location.serviceStatus.isDisabled) {
    if (kDebugMode) {
      logger.e("No Location Service Found!");
    }
    return false;
  }

  // All needed Permissions should be stored in this map and will be
  // requested when the method is called/map is instanziated
  Map<Permission, PermissionStatus> allPermissionsStatus = await [
    Permission.location,
    Permission.activityRecognition,
  ].request();

  allPermissionsStatus.forEach((key, currentStatus) {
    if (currentStatus.isGranted) {
      if (kDebugMode) {
        logger.i("Permission: $key already granted");
      }
      reqSuc = true;

    } else if (currentStatus.isDenied) {
      //currentStatus = await key.request();
      if (kDebugMode) {
        logger.i("Permission: $key was not acceppted!");
      }
      reqSuc = true;
      
    } else if (currentStatus.isPermanentlyDenied) {
      if (kDebugMode) {logger.i("Permission: $key is permanently denied");}
      openAppSettings();
      if (currentStatus.isGranted){
        reqSuc = true;
      }else{
        if (kDebugMode) {logger.i("Permission: $key still denied");}
      }
    }
  });

  return reqSuc;
}
