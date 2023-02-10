import 'package:flutter/material.dart';

import 'package:jog_dog/utilities/testStepSpeed.dart';
import 'package:jog_dog/utilities/debugLogger.dart';

class StartSessionButton extends StatelessWidget {
  const StartSessionButton({super.key, required this.currentSliderValue});
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
    const double tolerance = 0.05;
    

    //RunMusicLogic runLogic = RunMusicLogic(targetSpeed, tolerance);
    /*
    StepSensorData stepSensor = StepSensorData();
    stepSensor.stepPerSecond!.listen((event) {
      dataLogger.i(event);

    });
    */
  }
}
