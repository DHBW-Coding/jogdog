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
              child: const Text("Start Run"),
              onPressed: () {
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
            ),
    );
  }

  void startPressed() {
    RunMusicLogic().startRun(10, 0.5);
  }

  void stopPressed() {
    RunMusicLogic().finishRun();
  }
}
