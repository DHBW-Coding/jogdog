import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:jog_dog/utilities/run_music_logic.dart';
import 'package:jog_dog/utilities/debugLogger.dart' as logger;

class Session {

  final Map<int, double> _speeds = {};
  Map<int, double> get speeds => _speeds;
  final SensorData _sensors;
  bool _isRunning = false;
  late StreamSubscription _subscription;
  int _runStarted = 0;
  int _runEnded = 0;

  Session(this._sensors);

  void startTracking() {
    _isRunning = true;
    _runStarted = DateTime.now().millisecondsSinceEpoch;
    if(kDebugMode) logger.dataLogger.v("Session started at $_runStarted");
    _subscription = _sensors.normelizedSpeedStream.listen((double speed) {
      if (_isRunning) {
        _speeds[DateTime.now().millisecondsSinceEpoch] = speed;
        if(kDebugMode) logger.dataLogger.v("Raw GPS Speed: $speed, Timestamp: ${DateTime.now().millisecondsSinceEpoch}");
      } else {
        _subscription.cancel();
      }
    });

  }

  void stopTracking() {
    if (!_isRunning) { return; }
    _isRunning = false;
    _runEnded = DateTime.now().millisecondsSinceEpoch;
  }

  double getRunTime() {
    return (_runEnded - _runStarted)/1000;
  }

  double getTopSpeed() {
    double currentMaximum = 0;
    if (_speeds.isNotEmpty) {
      _speeds.forEach((key, value) {
          if (value > currentMaximum) {
            currentMaximum = value;
          }
      });
    }
    return currentMaximum;
  }

  double getAverageSpeed() {
    double sum = 0;
    if (_speeds.isNotEmpty) {
      _speeds.forEach((key, value) { sum += value; });
      return sum / _speeds.length;
    }
    return 0;
  }

}
