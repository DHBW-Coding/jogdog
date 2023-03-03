import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/run_music_logic.dart';
import 'package:jog_dog/utilities/session_manager.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../main.dart';
import '../widgets/spotifybutton.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTime = 0;
  int _currentSpeed = 10;
  bool _isRunning = SessionManager().isRunning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              sessionDisplay(),
              const SizedBox(
                height: 40,
              ),
              speedSelector(),
              startRunButton(),
              const SizedBox(
                height: 20,
              ),
              const SpotifyButton(),
            ],
          ),
        ),
      ),
    );
  }

  sessionDisplay() {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: ListTile(
            leading: const Icon(Icons.timer),
            title: Text(
              //Time in HH:MM:SS format from currentTime
              "${(currentTime / 3600).floor().toString().padLeft(2, "0")}:"
              "${((currentTime % 3600) / 60).floor().toString().padLeft(2, "0")}:"
              "${(currentTime % 60).toString().padLeft(2, "0")}",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            subtitle: Text(
              "Time into session",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }

  speedSelector() {
    return AbsorbPointer(
      absorbing: _isRunning,
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(
          size: 300,
          customColors: CustomSliderColors(
            progressBarColor: Theme.of(context).colorScheme.primary,
            trackColor: Theme.of(context).colorScheme.onInverseSurface,
            dotColor: Theme.of(context).colorScheme.primary,
          ),
          customWidths: CustomSliderWidths(
            progressBarWidth: 25,
            trackWidth: 25,
            handlerSize: 25,
            shadowWidth: 0,
          ),
          infoProperties: InfoProperties(
            mainLabelStyle: Theme.of(context).textTheme.displayMedium,
            bottomLabelText: "Selected Speed",
            bottomLabelStyle: Theme.of(context).textTheme.labelLarge,
            modifier: (double value) {
              return "${value.toInt()} km/h";
            },
          ),
        ),
        min: 5,
        max: 20,
        initialValue: 10,
        onChange: (double value) {
          _currentSpeed = value.toInt();
          if (kDebugMode) {
            logger.i("Speed: $value\n"
                "Current speed selected: $_currentSpeed");
          }
        },
      ),
    );
  }

  startRunButton() {
    return SizedBox(
      height: 45,
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
    RunMusicLogic().startRun(_currentSpeed.toDouble(), 0.5);
  }

  void stopPressed() {
    RunMusicLogic().finishRun();
  }
}
