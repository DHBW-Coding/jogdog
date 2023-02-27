import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jog_dog/utilities/debug_logger.dart' as logger;
import 'package:jog_dog/utilities/local_music_controller.dart';
import 'package:jog_dog/utilities/session_manager.dart';

/// Main Logic Function to get the music speed change factor
/// which should be forwarded to the musicInterface
/// [_targetSpeed] should be the value the user inputs over the UI
/// and [_tolerance] can be set manually on the settings page or is
/// 0.5 m/s on default
class RunMusicLogic {

  final _sensors = SensorData();
  final double _tolerance; 
  final double _targetSpeed;
  final int musicSpeedSetRate = 0; // TODO: implement
  double _prevMusicSpeed = 0;
  bool isAtTargetSpeed = false;

  /// Todo: MusicController required machen?
  RunMusicLogic([this._targetSpeed = 10, this._tolerance = 0.1]){
    _changeMusicSpeed();
    SessionManager().createNewSession();
  }

  void _changeMusicSpeed() {
    /// Todo: Reschschreibfehler rausnehmen
    _sensors.normelizedSpeedStream.listen((currentSpeed) { 
      logger.dataLogger.d("Current NormSpeed: $currentSpeed");
      double musicChangeFactor = currentSpeed / _targetSpeed;
      double speedDiff = _prevMusicSpeed - musicChangeFactor;


      if (_prevMusicSpeed == 0 || speedDiff.abs() >= _tolerance) {
        _prevMusicSpeed = musicChangeFactor;
        localMusicController().setPlaybackSpeed(musicChangeFactor);
        logger.dataLogger.i("Current musicChFac: $musicChangeFactor");
      }
    });
  }
}

/// Sensor Class to report current normelized speed of the device
/// Uses GPS Data to perform these kind of callculations
class SensorData {

  static final SensorData _instance = SensorData._internal();

  final StreamController<double> _streamCtrl = StreamController.broadcast();
  final List<double> _speeds = []; // List is a pointer pointing to different doubles thats why final
  late LocationSettings _settings;
  bool isRunning = false;

  factory SensorData() {
    return _instance;
  }

  SensorData._internal() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _settings = AndroidSettings(
        accuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
        intervalDuration: const Duration(milliseconds: 500),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: "JogDog jogging in Background",
          notificationText:
          "Your jog Dog will also check your speed if the app is in Background, but only if you are in an active running session!",
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

    /// Todo: [Test] Does the Periodic Timer "2-Secs-Wait" block the stream listening?
    Geolocator.getPositionStream(locationSettings: _settings).listen(
      (Position dataPoint) {
        if(kDebugMode) logger.dataLogger.v("SpeedAccuracy:${dataPoint.speedAccuracy}");
        if(dataPoint.speedAccuracy < 0.7 && dataPoint.speedAccuracy != 0.0){
          _speeds.add(dataPoint.speed);
        }
        if(kDebugMode) logger.dataLogger.v("Raw GPS Speed: ${dataPoint.speed}");
      },
      onError: (err) {
        if(kDebugMode) logger.dataLogger.e("Error on PositionStream: $err");
      }
    );

    /// TODO: create stop streamlistening method
    int i = 0;
    const int sec = 2;
    const int secToTrack = 8;
    Timer.periodic(const Duration(seconds: sec), (timer) {
      if(!isRunning){
        i++;
        if(_isDataReliable(_speeds) || i>=(secToTrack/sec)){ // Wait until data is reliable or 8 sec
          isRunning = true;
          i = 0;
        }
      }
      else if(_speeds.isNotEmpty){
        _streamCtrl.add(median(_speeds)); // TEST: If data is not good enough make something better

        if(_speeds.length > 5){
          _speeds.removeRange(0, _speeds.length - 5);
        }
      }
      else{
        if(kDebugMode) logger.dataLogger.e("GPS Module active but no accurat data reciving");
      }
    });
  }

  /// Checks if last values are nearly 0 m/s
  bool _isDataReliable(List<double> speeds){
    int lenght = speeds.length;
    if(lenght <= 3){
      return false;
    }
    for(int i = 1; i<4; i++){

      if(speeds[lenght-i] == 0.0 || speeds[lenght-i] > 0.5) // If the Data is exactly 0.0 then there is no GPS Data
      {
        return false;
      }
    }
    return true;
  }

  /// Publish every 2 secondsy the current Speed (Normelization currently only median of data during this 2 seconds)
  Stream<double> get normelizedSpeedStream{
    return _streamCtrl.stream;
  }
}

double deviation(List values) {
  double d = 0.0;
  return d;
}

double median(List values) {
  values.sort();

  int n = values.length;
  if(n.isOdd){
    num x = (n+1)/2;
    return values[x.toInt() - 1];
  }else{
    num x = n/2;
    return (values[x.toInt() - 1] + values[x.toInt()]) / 2;
  }
}
