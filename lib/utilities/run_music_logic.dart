import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jog_dog/utilities/debug_logger.dart' as logger;
import 'package:jog_dog/utilities/local_music_controller.dart';
import 'package:jog_dog/utilities/session_manager.dart';

/// Main Logic Function to get the music speed change factor
/// which should be forwarded to a musicInterface
/// [_targetSpeed] should be the value the user inputs over the UI
/// and [_tolerance] can be set manually on the settings page or is
/// 0.5 m/s on default
class RunMusicLogic {
  static final RunMusicLogic _instance = RunMusicLogic._internal();

  // int musicSpeedSetRate = 0;
  double _prevMusicSpeed = 0;
  late double _tolerance;
  late double _targetSpeed;

  factory RunMusicLogic() {
    return _instance;
  }

  RunMusicLogic._internal();

  void startRun(double targetSpeed, double tolerance) {
    _targetSpeed = targetSpeed / 3.6;
    _tolerance = tolerance;
    SensorData().startTracking();
    SessionManager().createNewSession();
    _fadeMusicIn();
  }

  void finishRun() {
    SessionManager().stopSessionTracking(true);
    SensorData().stopTracking();
  }

  void _fadeMusicIn() {
    //TODO: Kurve die die Musik immer Lauter und Schneller macht
    _changeMusicSpeed();
  }

  void _changeMusicSpeed() {
    SensorData().normalizedSpeedStream.listen(
      (currentSpeed) {
        logger.dataLogger.d("Current NormSpeed: $currentSpeed");
        double musicChangeFactor = currentSpeed / _targetSpeed;
        double speedDiff = (_prevMusicSpeed - musicChangeFactor).abs();

        if (_prevMusicSpeed == 0 || speedDiff >= _tolerance) {
          _prevMusicSpeed = musicChangeFactor;

          if (0.25 < musicChangeFactor && musicChangeFactor < 2) {
            localMusicController().setPlaybackSpeed(musicChangeFactor);
          } else {
            localMusicController()
                .setPlaybackSpeed(musicChangeFactor < 0.25 ? 0.25 : 2);
          }

          logger.dataLogger.i("Current musicChFac: $musicChangeFactor");
        }
      },
    );
  }
}

/// Sensor Class to report current normalized speed of the device
/// Uses GPS Data to perform these kind of calculations
class SensorData {
  static final SensorData _instance = SensorData._internal();

  late StreamController<double> _streamCtrl;
  final List<double> _speeds = [];
  bool isDataReliable = false;
  bool gpsInUsage = false;
  late LocationSettings _settings;
  late StreamSubscription _gpsSubscription;
  late Timer dataStreamTimer;

  factory SensorData() {
    return _instance;
  }

  SensorData._internal() {
    _setSettings();
  }

  void _setSettings() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _settings = AndroidSettings(
        accuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
        intervalDuration: const Duration(milliseconds: 250),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: "JogDog jogging in Background",
          notificationText:
              "Your jog Dog will also check your speed if the app is in Background,"
              "but only if you are in an active running session!",
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      _settings = AppleSettings(
        accuracy: LocationAccuracy.best,
        activityType: ActivityType.fitness,
        allowBackgroundLocationUpdates: true,
        timeLimit: const Duration(seconds: 10),
        showBackgroundLocationIndicator: false,
      );
    } else {
      _settings = const LocationSettings(
        accuracy: LocationAccuracy.best,
      );
    }
  }

  void startTracking() {
    _startGPSStream();
    _startDataStream();
  }

  Future<void> stopTracking() async {
    _gpsSubscription.cancel();
    if (kDebugMode) {
      logger.dataLogger.i("GPS Stream canceled");
    }
    _streamCtrl.close();
    dataStreamTimer.cancel();
    gpsInUsage = false;
  }

  void _startGPSStream() {
    _gpsSubscription =
        Geolocator.getPositionStream(locationSettings: _settings).listen(
      (Position dataPoint) {
        if (kDebugMode) {
          logger.dataLogger.v("SpeedAccuracy: ${dataPoint.speedAccuracy}");
        }
        if (dataPoint.speedAccuracy < 0.7) {
          _speeds.add(dataPoint.speed);
        }
        if (kDebugMode) {
          logger.dataLogger.v("Raw GPS Speed: ${dataPoint.speed}");
        }
      },
      onError: (err) {
        if (kDebugMode) logger.dataLogger.v("Error on PositionStream: $err");
      },
    );
  }

  void _startDataStream() {
    int i = 0;
    const int sec = 2;
    const int secToTrack = 8;
    _streamCtrl = StreamController.broadcast();
    dataStreamTimer = Timer.periodic(
      const Duration(seconds: sec),
      (timer) {
        if (!isDataReliable) {
          i++;
          // Wait until data is reliable or 8 sec
          if (_isDataReliable(_speeds) || i >= (secToTrack / sec)) {
            isDataReliable = true;
            i = 0;
          }
        } else if (_speeds.isNotEmpty && dataStreamTimer.isActive) {
          var normedSpeed = median(_speeds);
          _streamCtrl.add(normedSpeed);

          // if(normedSpeed < 0.6){
          //   i++;
          //   if(i == 4) isRunning = false;
          // }else{
          //   i = 0;
          // }

          if (_speeds.length > 5) {
            _speeds.removeRange(0, _speeds.length - 5);
          }
        } else {
          if (kDebugMode) {
            logger.dataLogger
                .e("GPS Module active but no accurat data reciving");
          }
        }
      },
    );
  }

  /// Checks if last values are note deviated too much
  bool _isDataReliable(List<double> speeds) {
    int lenght = speeds.length;
    if (lenght <= 5) return false;
    List<double> newest5speeds = speeds.getRange(lenght - 5, lenght).toList();
    if (newest5speeds.where((x) => x == 0.00).length >= 2) return false;

    double m = median(newest5speeds);
    double variance =
        newest5speeds.map((x) => pow(x - m, 2)).reduce((a, b) => (a + b)) /
            (lenght - 1);
    double stdDev = sqrt(variance);

    if (kDebugMode) {
      logger.dataLogger.i("Standart Deviation of last 5 Speeds: $stdDev");
    }

    if (stdDev > 1.5) {
      return false;
    } else {
      return true;
    }
  }

  /// Publish every 2 seconds the current Speed
  Stream<double> get normalizedSpeedStream {
    return _streamCtrl.stream;
  }
}

/// Calulates the median of the givens [values] of a list
double median(List values) {
  values.sort();

  int n = values.length;
  if (n.isOdd) {
    num x = (n + 1) / 2;
    return values[x.toInt() - 1];
  } else {
    num x = n / 2;
    return (values[x.toInt() - 1] + values[x.toInt()]) / 2;
  }
}
