import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:clock/clock.dart';

import 'package:jog_dog/utilities/debugLogger.dart' as Logger;

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

  final List<double> _speeds = []; // List is a pointer pointing to diffrent doubles thats why final

  SensorData() {
    int i = 0;

    Geolocator.getPositionStream().listen((Position dataPoint) {
      _speeds.add(dataPoint.speed);
      //TODO: Position.speedAccracy for data norming maybe
      Logger.dataLogger.v(_speeds[i]);

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
