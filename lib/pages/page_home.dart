import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/runSpeedTracker.dart';

import 'package:logger/logger.dart';


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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: Container(
                        width: 315,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text("Display Timer time"),
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(150)),
                    child: SizedBox(
                        width: 300,
                        height: 300,
                        child: Center(
                          child: Text(
                            "${_currentSliderValue.round()} km/h",
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        )),
                  ),
                ],
              ),
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
              SizedBox(
                width: 315,
                child: ElevatedButton(
                  onPressed: () {startPressed(_currentSliderValue);},
                  child: const Text(
                    "Start Run",
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 315,
                height: 50,
                child: ElevatedButton(
                  child: const Text("Connect to Spotify"),
                  onPressed: () {},
                ),
              )
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
    

  }
}
