import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class Session {
  final List<double> _speeds = [];
  final List<int> _timestamps = [];
  final Stopwatch _stopwatch = Stopwatch()..start();
  final double _targetSpeed;

  Session(this._targetSpeed);

  void addSpeed(double speed) {
    _speeds.add(speed);
    _timestamps.add(_stopwatch.elapsedMilliseconds);
  }

  List<double> get speeds => _speeds;
  List<int> get timestamps => _timestamps;

  void reset() {
    _speeds.clear();
    _timestamps.clear();
    _stopwatch.reset();
  }

  void stop() {
    _stopwatch.stop();
  }

  void start() {
    _stopwatch.start();
  }

  void trackSpeed() {
    userAccelerometerEvents.listen((var dataPoint) {
      // Calculate Speed in m/s from three dimensional acceleration (m/s^2) dividied by 1000ms
      addSpeed(sqrt(pow(dataPoint.x, 2) + pow(dataPoint.z, 2) + pow(dataPoint.y, 2)) * _stopwatch.elapsedMilliseconds / 1000);
      _stopwatch.reset();
    });
  }

}
