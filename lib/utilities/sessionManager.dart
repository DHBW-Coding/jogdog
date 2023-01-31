import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:jog_dog/utilities/run_music_logic.dart';
import 'package:jog_dog/utilities/debugLogger.dart' as logger;

class Session {

  final Map<int, double> _speeds = {};
  final SensorData _sensors;
  bool _isRunning = false;
  late StreamSubscription _subscription;

  Session(this._sensors);

  void addSpeed(double speed, int timestamp) {
    _speeds[timestamp] = speed;
  }

  void start() {
    _isRunning = true;
    trackTargetSpeed();
    if(kDebugMode) logger.dataLogger.v("Session started at ${DateTime.now().millisecondsSinceEpoch}");
  }

  void stop() {
    _isRunning = false;
  }

  void trackTargetSpeed() {
    _subscription = _sensors.normelizedSpeedStream.listen((double speed) {
      if (_isRunning) {
        addSpeed(speed, DateTime.now().millisecondsSinceEpoch);
        if(kDebugMode) logger.dataLogger.v("Raw GPS Speed: $speed, Timestamp: ${DateTime.now().millisecondsSinceEpoch}");
      } else {
        _subscription.cancel();
      }
    });

  }

  Map<int, double> get speeds => _speeds;

}
