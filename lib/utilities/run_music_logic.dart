import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:sensors_plus/sensors_plus.dart';

import 'package:jog_dog/providers/music_interface.dart';
import 'package:jog_dog/utilities/debugLogger.dart' as logger;
import 'package:jog_dog/utilities/sessionManager.dart';

/// Main Logic Function to get the music speed change faktor 
/// which should be forwarded to the musicInterface
/// [_targetSpeed] should be the value the user inputs over the UI
/// and [_tolerance] can be set manually on the settings page or is
/// 0.5 m/s on default
class RunMusicLogic {

  final _sensors = SensorData();
  final double _tolerance; 
  final double _targetSpeed;
  final int musicSpeedSetRate = 0; // TODO: implement
  double _prevSpeed = 0;

  RunMusicLogic([this._targetSpeed = 10, this._tolerance = 0.5]){
    _changeMusicSpeed();
    Session session = Session(_sensors);
    session.startTracking();
  }

  void _changeMusicSpeed() {
    _sensors.normelizedSpeedStream.listen((currentSpeed) { 
      logger.dataLogger.d(currentSpeed);
      double speedDiff = _prevSpeed - currentSpeed;
      double musicChangeFactor = currentSpeed / _targetSpeed;
      _prevSpeed = currentSpeed;

      if (speedDiff.abs() > _tolerance && musicChangeFactor >= 0.1) {
        MusicInterface.setSpeed(musicChangeFactor);
        logger.dataLogger.i(musicChangeFactor);
      }
    });
  }
}

// Get speed information from GPS in a list
class SensorData {

  final StreamController<double> _streamCtrl = StreamController.broadcast();
  final List<double> _speeds = []; // List is a pointer pointing to diffrent doubles thats why final
  final LocationSettings _settings = AndroidSettings( // TODO: Settings only valid for Android
      accuracy: LocationAccuracy.best,
      timeLimit: const Duration(seconds: 10),
      intervalDuration: const Duration(milliseconds: 500),
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationTitle: "JogDog jogging in Background", 
        notificationText: "Your jog Dog will also check your speed if the app is in Background, but only if you are in an active running session!")
    );

  SensorData() {
    // TODO: Position.speedAccuracy for data norming maybe
    Geolocator.getPositionStream(locationSettings: _settings).listen(
      (Position dataPoint) {
        // TODO: Edge case, stop and start run
        _speeds.add(dataPoint.speed);
        if(kDebugMode) logger.dataLogger.v("Raw GPS Speed: ${dataPoint.speed}");
      },
      onError: (err) {
        if(kDebugMode) logger.dataLogger.e("Error on PositionStream: $err");
      }
    );

    Timer.periodic(const Duration(seconds: 2), (t) { 
      if(_speeds.isNotEmpty){
        _streamCtrl.add(median(_speeds)); // TODO: Maybe something better in the futur
        _speeds.clear();
      }
    });
  }

  /// Publish every 2 secondsy the current Speed (Normelization currently only median of data during this 2 seconds)
  Stream<double> get normelizedSpeedStream{
    return _streamCtrl.stream;
  }
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
