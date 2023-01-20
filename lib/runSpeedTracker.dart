import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:clock/clock.dart';

// Main Logic Function
class RunMusicLogic {

  static final SensorData _sensors = SensorData();
  final double _tolerance;
  final double _targetSpeed;
  double _prevSpeed = 0;

  RunMusicLogic(this._targetSpeed, this._tolerance);

  double _normSpeedDiff() {
    var currentSpeed = average(_sensors.speeds); //TODO: maybe something better in the future
    double speedDiff = _prevSpeed - currentSpeed.abs();
    _prevSpeed = speedDiff;

  // Edge case, stop and start run //TODO: Implement this
    if (speedDiff > _tolerance) {
      return _targetSpeed / speedDiff;
    } else {
      return 1;
    }
  }

  num get musicChangeFactor {
    //TODO: some function to be modelled for testing quadratic
    return pow(_normSpeedDiff(), 2);
    //TODO: add call to interface.musicChangeSpeed 
  }
}

// get Accelerometer, convert to one directional speed from three dimensional velocity
class SensorData {

  final Stopwatch _stopwatch = clock.stopwatch()..start();
  final List<double> _speeds = []; // List is a pointer pointing to diffrent doubles thats why final

  SensorData() {
    int i = 0;
    userAccelerometerEvents.listen((var dataPoint) {
      int timestamp = _stopwatch.elapsedMilliseconds;
      // Calculate Speed in m/s from three dimensional acceleration (m/s^2) dividied by 1000ms 
      _speeds.add(sqrt(pow(dataPoint.x, 2) + pow(dataPoint.z, 2) + pow(dataPoint.y, 2)) * timestamp / 1000);
      _stopwatch.reset();
      print(_speeds[i]);
      i++;
    });
  }

  List<double> get speeds {
    var v = _speeds;
    _speeds.clear();
    return v;
  }
}

num average(List values) {
  double sum = 0;
  for (var value in values) {
    sum += value;
  }
  return sum / values.length;
}
