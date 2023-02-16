import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jog_dog/pages/page_home.dart';
import 'package:jog_dog/providers/music_interface.dart';
import 'package:jog_dog/utilities/local_music_controller.dart';
import 'package:jog_dog/utilities/run_music_logic.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:jog_dog/pages/page_history.dart';
import 'package:jog_dog/pages/page_settings.dart';
import 'package:jog_dog/theme/theme.dart';
import 'package:jog_dog/utilities/debugLogger.dart';

var logger;

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  MusicInterface musicController = localMusicController();
  RunMusicLogic run = RunMusicLogic(musicController: musicController, tolerance: 0.5);

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
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int currentPageIndex = 0;
  late MusicInterface musicController;

  @override
  void initState(){
    super.initState();
    musicController = localMusicController();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
            Home(
              title: 'Home',
              musicController: musicController,
            ),
            const History(),
            const Settings()
          ][currentPageIndex],
        ));
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
    // Permission.audio  
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
      if (kDebugMode) {
        logger.i("Permission: $key is permanently denied");
      }
      openAppSettings();
      if (currentStatus.isGranted) {
        reqSuc = true;
      } else {
        if (kDebugMode) {
          logger.i("Permission: $key still denied");
        }
      }
    }
  });

  return reqSuc;
}
