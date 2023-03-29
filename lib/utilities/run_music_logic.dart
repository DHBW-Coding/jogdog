import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'package:jog_dog/utilities/debug_logger.dart' as logger;
import 'package:jog_dog/utilities/local_music_controller.dart';
import 'package:jog_dog/utilities/session_manager.dart';
import 'package:jog_dog/utilities/settings.dart';

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

  void startRun() {
    _targetSpeed = Settings().targetSpeed.toDouble() / 3.6;
    _tolerance = Settings().tolerance;
    SensorData().startTracking();
    SessionManager().createNewSession();
    SessionManager().continueSessionTracking();
    _fadeMusicIn();
  }

  void finishRun() {
    localMusicController().setPlaybackSpeed(1);
    SessionManager().stopSessionTracking(true);
    SensorData().stopTracking();
  }

  void pauseRun() {
    // TODO: Implement (Low Prio)
  }

  void _fadeMusicIn() {
    // TODO: Kurve die die Musik immer Lauter und Schneller macht (Low Prio)
    _changeMusicSpeed();
  }

  void _changeMusicSpeed() {

    SensorData().normalizedSpeedStream.listen((currentSpeed) {
        logger.dataLogger.w("Current NormSpeed: $currentSpeed");
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

          logger.dataLogger.w("Current musicChFac: $musicChangeFactor");
        }
      },
    );
  }
}

/// Sensor Class to report current normalized speed of the device
/// Uses GPS Data to perform these kind of calculations
class SensorData {
  static final SensorData _instance = SensorData._internal();
  final Queue<double> _speeds = Queue<double>();

  bool _isDataReliable = false;
  
  late StreamController<double> _streamCtrl;
  late LocationSettings _settings;
  late StreamSubscription _gpsSubscription;
  late Timer _dataStreamTimer;
  late double _currentSpeedInKmh = 0;
  double get currentSpeedInKmh => _currentSpeedInKmh;
  int _inertia = Settings().inertia;

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
        showBackgroundLocationIndicator: true,
      );
    } else {
      _settings = const LocationSettings(
        accuracy: LocationAccuracy.best,
      );
    }
  }

  void startTracking() {
    _speeds.clear();
    _startGPSStream();
    _startDataStream();
  }

  Future<void> stopTracking() async {
    _dataStreamTimer.cancel();
    _gpsSubscription.cancel();
    _streamCtrl.close();
    if (kDebugMode) { // TODO: Hauen wir die Debugs raus oder machen einzeiler draus?
      logger.dataLogger.i("GPS Stream canceled");
    }
  }

  void _startGPSStream() {
    _gpsSubscription =
      Geolocator.getPositionStream(locationSettings: _settings)
      .listen((Position dataPoint) {

        if (dataPoint.speedAccuracy < 0.7) {
          if(dataPoint.speed <= 0){
            _speeds.addLast(0);
          }else{
            _speeds.addLast(dataPoint.speed);
          }
          if(_speeds.length > _inertia) _speeds.removeFirst();
        }
        if (kDebugMode) { logger.dataLogger.d("Raw GPS Speed: ${dataPoint.speed}");}
      },
      onError: (err) {
        if (kDebugMode) logger.dataLogger.w("Error on PositionStream: $err");
      },
    );
  }

  void _startDataStream() {
    int i = 0;
    const int sec = 1;
    const int secToTrack = 8;
    _streamCtrl = StreamController.broadcast();
    _dataStreamTimer = Timer.periodic(const Duration(seconds: sec), (timer) {
        if (!_isDataReliable) {
          i++;
          // Wait until data is reliable or until 8 sec passed
          if (isDataReliable(_speeds.toList()) || i >= (secToTrack / sec)) {
            _isDataReliable = true;
            i = 0;
          }
        } else if (_speeds.isNotEmpty && _dataStreamTimer.isActive) {
          var normedSpeed = median(_speeds.toList());
          _currentSpeedInKmh = normedSpeed * 3.6;
          _streamCtrl.add(normedSpeed);
        } else {
          if (kDebugMode) logger.dataLogger.e("GPS Module active but no accurat data reciving");
        }
      },
    );
  }

  /// Publish every 2 seconds the current Speed
  Stream<double> get normalizedSpeedStream {
    return _streamCtrl.stream;
  }
}

/// Checks if last values are note deviated too much
bool isDataReliable(List<double> speeds) {
  int length = speeds.length;
  if (length <= 5) return false;
  List<double> newest5speeds = speeds.getRange(length - 5, length).toList();
  if (newest5speeds.where((x) => x <= 0.00).length >= 2) return false;

  double m = median(newest5speeds);
  double variance =
      newest5speeds.map((x) => pow(x - m, 2)).reduce((a, b) => (a + b)) / (length - 1);
  double stdDev = sqrt(variance);

  if (stdDev > 1.5) {
    return false;
  } else {
    return true;
  }
}

/// Calculates the median of the givens [values] of a list
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
