import 'package:flutter/material.dart';
import 'package:jog_dog/runSpeedTracker.dart';

class StartSessionButton extends StatelessWidget {
  StartSessionButton({super.key, required currentSliderValue}) {
    double _currentSliderValue = currentSliderValue;
  }
  final double _currentSliderValue = 0;

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
    /*
    double targetSpeed = _currentSliderValue;
    const double tolerance = 1;
    RunMusicLogic runLogic = RunMusicLogic(targetSpeed, tolerance);
    var musicChangeFactor = runLogic.musicChangeFactor;
    */
  }
}
