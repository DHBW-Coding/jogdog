import 'dart:collection';
import 'dart:async';

import 'package:pedometer/pedometer.dart';

import 'package:jog_dog/utilities/debug_logger.dart';

class StepSensorData {

  Stream<double>? stepPerSecond;

  var startStepCount;
  final StreamController<double> streamCtrl = StreamController();
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  Queue<StepCount> events = Queue();

  StepSensorData() {
    stepPerSecond = streamCtrl.stream;
    _stepCountStream = Pedometer.stepCountStream
      ..listen(onStepIncrease).onError(stepError);
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream
      ..listen(onPedestrianStatusChange).onError(pedestrianStatusError);
  }


  void onStepIncrease(StepCount event) {
    if(events.isNotEmpty){
      dataLogger.i("Steps: ${events.last.steps - events.first.steps}");
    }
    if (events.length < 12) {
      events.add(event);
    } else {
      double stepPerTime = (
              events.last.timeStamp.difference(events.first.timeStamp)
              .inMilliseconds / (1000 * (events.last.steps - events.first.steps))
              );
      streamCtrl.add(stepPerTime);
      events.removeFirst();
      events.removeFirst();
      events.add(event);
    }
  }

  void stepError(error) {
    streamCtrl.close();
    allLogger.e("stepError accoured: $error");
  }

  void onPedestrianStatusChange(PedestrianStatus status) {
    streamCtrl.add(-1);
  }

  void pedestrianStatusError(error) {
    streamCtrl.close();
    allLogger.e("pedestrainStepError accoured: $error");
    //
  }

}
