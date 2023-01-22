import 'dart:collection';

import 'package:pedometer/pedometer.dart';
import 'dart:async';

class SensorData {
  Stream<double>? stepPerSecond;
  final StreamController<double> controller = StreamController();
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  late Queue<StepCount> events;

  void onStepIncrease(StepCount event) {
    if (events.length > 9 && events.length < 12) {
      events.add(event);
    } else {
      double stepPerTime = (events.first.timeStamp
              .difference(events.last.timeStamp)
              .inMilliseconds /
          (1000 * events.last.steps));
      controller.add(stepPerTime);
      events.removeFirst();
      events.removeFirst();
      events.add(event);
    }
  }

  void stepError(error) {
    controller.close();
    //
  }

  void onPedestrianStatusChange(PedestrianStatus status) {
    controller.add(-1);
  }

  void pedestrianStatusError(error) {
    controller.close();
    //
  }

  SensorData() {
    stepPerSecond = controller.stream;
    _stepCountStream = Pedometer.stepCountStream
      ..listen(onStepIncrease).onError(stepError);
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream
      ..listen(onPedestrianStatusChange).onError(pedestrianStatusError);
  }
}
