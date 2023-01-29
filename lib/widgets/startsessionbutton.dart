import 'package:flutter/material.dart';

import 'package:jog_dog/utilities/runSpeedTracker.dart';
import 'package:jog_dog/utilities/testStepSpeed.dart';
import 'package:jog_dog/utilities/debugLogger.dart';

class StartSessionButton extends StatelessWidget {
  StartSessionButton({super.key, required this.currentSliderValue}) {}
  final double currentSliderValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 315,
      child: ElevatedButton(
        onPressed: startPressed,
        child: const Text(
          "Start Run",
        ),
      ),
    );
  }

  void startPressed() {
    double targetSpeed = currentSliderValue;
    const double tolerance = 1;
    RunMusicLogic runLogic = RunMusicLogic(targetSpeed, tolerance);
    var musicChangeFactor = runLogic.musicChangeFactor;
    /*
    StepSensorData stepSensor = StepSensorData();
    stepSensor.stepPerSecond!.listen((event) {
      dataLogger.i(event);

    });
    */
  }
}
