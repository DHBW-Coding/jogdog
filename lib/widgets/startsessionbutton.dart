import 'package:flutter/material.dart';
import 'package:jog_dog/runSpeedTracker.dart';

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

  void startPressed() {}
}
