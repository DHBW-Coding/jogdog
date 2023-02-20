import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/run_music_logic.dart';

class StartSessionButton extends StatefulWidget {
  const StartSessionButton({super.key, required this.currentSliderValue});

  final double currentSliderValue;

  @override
  StartSessionButtonState createState() => StartSessionButtonState();
}

class StartSessionButtonState extends State<StartSessionButton> {
  bool _isStarted = false;
  late RunMusicLogic _runLogic;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _isStarted
          ? ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    _isStarted = false;
                    stopPressed();
                  },
                );
              },
              child: const Text("Stop Run"))
          : ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    _isStarted = true;
                    startPressed();
                  },
                );
              },
              child: const Text("Start Run"),
            ),
    );
  }

  void startPressed() {
    double targetSpeed = widget.currentSliderValue;
    const double tolerance = 0.05;
    _runLogic = RunMusicLogic(targetSpeed, tolerance);
    /*
    StepSensorData stepSensor = StepSensorData();
    stepSensor.stepPerSecond!.listen((event) {
      dataLogger.i(event);

    });
    */
  }

  void stopPressed() {}
}
