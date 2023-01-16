import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:clock/clock.dart';
import 'dart:math';

// Main Logic Function
class RunMusicLogic {
  static final SensorData _sensors = SensorData();
  double _prevSpeed = 0;
  final double _targetSpeed;
  final double _tolerance;
  RunMusicLogic(this._targetSpeed, this._tolerance);
  double _normSpeedDiff() {
    var currentSpeed =
        average(_sensors.speeds); //maybe something better in the future
    double speedDiff = _prevSpeed - currentSpeed.abs();
    _prevSpeed = speedDiff;
  //edge case, stop and start run
    if (speedDiff > _tolerance) {
      return _targetSpeed / speedDiff;
    } else {
      return 1;
    }
  }

  void musicChangeFactor() {
    //some function to be modelled for testing quadratic
    pow(_normSpeedDiff(), 2);
    //add call to interface.musicChangeSpeed 
  }
}

// get Accelerometer, convert to one directional speed from three dimensional velocity
class SensorData {
  final _stopwatch = clock.stopwatch()..start();
  List<double> _speeds = [];
  SensorData() {
    userAccelerometerEvents.listen((var event) {
      int timestamp = _stopwatch.elapsedMilliseconds;
      _speeds.add(sqrt(pow(event.x, 2) + pow(event.z, 2) + pow(event.y, 2)) *
          timestamp *
          1000);
      _stopwatch.reset();
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
