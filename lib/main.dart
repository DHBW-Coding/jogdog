import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jog_dog/theme/theme.dart';
import 'package:jog_dog/utilities/debug_logger.dart';
import 'package:jog_dog/utilities/session_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import 'pages/page_navigation.dart';

var logger;

void main() {
  runApp(const MyApp());
  SessionManager().loadSessionsFromJson();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requestPermissions(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const NavigationPage(),
        );
      },
    );
  }
}

Future<void> requestPermissions() async {
  if (await Permission.location.serviceStatus.isDisabled) {
    if (kDebugMode) {
      logger.e("No Location Service Found!");
    }
    return;
  }

  // All needed Permissions should be stored in this map and will be
  // requested when the method is called/map is instantiated
  Map<Permission, PermissionStatus> allPermissionsStatus = await [
    Permission.location,
    Permission.storage,
  ].request();

  allPermissionsStatus.forEach(
    (key, currentStatus) {
      if (currentStatus.isGranted) {
        if (kDebugMode) {
          logger.i("Permission: $key already granted");
        }
      } else if (currentStatus.isDenied) {
        //currentStatus = await key.request();
        if (kDebugMode) {
          logger.i("Permission: $key was not acceppted!");
        }
      } else if (currentStatus.isPermanentlyDenied) {
        if (kDebugMode) {
          logger.i("Permission: $key is permanently denied");
        }
        openAppSettings();
        if (currentStatus.isGranted) {
        } else {
          if (kDebugMode) {
            logger.i("Permission: $key still denied");
          }
        }
      }
    },
  );
}
