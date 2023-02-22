import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/run_music_logic.dart';
import 'package:jog_dog/utilities/session_manager.dart';

class StartSessionButton extends StatefulWidget {
  const StartSessionButton({super.key, required this.currentSliderValue});

  final double currentSliderValue;

  @override
  StartSessionButtonState createState() => StartSessionButtonState();
}

class StartSessionButtonState extends State<StartSessionButton> {
  bool _isRunning = SessionManager().isRunning;
  late RunMusicLogic _runLogic;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _isRunning
          ? ElevatedButton(
              child: const Text("Stop Run"),
              onPressed: () {
                setState(
                  () {
                    _isRunning = false;
                    stopPressed();
                  },
                );
              },
      )
          : ElevatedButton(
              onPressed: () {
    child: const Text("Start Run"),)
                setState(
                  () {
                    _isRunning = !_isRunning;
                    if (_isRunning) {
                      startPressed();
                    } else {
                      stopPressed();
                    }
                  },
                );
              },
              ,
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

  void stopPressed() {
    SessionManager().stopSessionTracking(true);
  }
}
