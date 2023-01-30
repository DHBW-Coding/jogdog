import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class Session {

  final Map<int, double> _speeds = {};
  final Stopwatch _stopwatch = Stopwatch()..start();
  final double _targetSpeed;

  Session(this._targetSpeed);

  void addSpeed(double speed, int timestamp) {
    _speeds[timestamp] = speed;
  }

  Map<int, double> get speeds => _speeds;

  void stop() {
    _stopwatch.stop();
  }

  void start() {
    _stopwatch.start();
  }


}
