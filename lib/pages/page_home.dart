import 'package:flutter/material.dart';
import 'package:jog_dog/widgets/spotifybutton.dart';
import 'package:jog_dog/widgets/sessiondisplay.dart';
import 'package:jog_dog/widgets/speedometer.dart';
import 'package:jog_dog/widgets/startsessionbutton.dart';

import 'package:jog_dog/utilities/runSpeedTracker.dart';
import 'package:jog_dog/utilities/testStepSpeed.dart';
import 'package:jog_dog/utilities/debugLogger.dart';


class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double _currentSliderValue = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SessionDisplay(),
              const SizedBox(
                height: 15,
              ),
              Speedometer(speedValue: _currentSliderValue),
              Slider(
                value: _currentSliderValue,
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
                max: 15,
                min: 1,
              ),
              StartSessionButton(currentSliderValue: _currentSliderValue),
              const SizedBox(
                height: 15,
              ),
              const SpotifyButton(),
            ],
          ),
        ),
      ),
    );
  }

  void startPressed(double currentSliderValue) 
  {
    
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
