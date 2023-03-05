import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jog_dog/utilities/run_music_logic.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../main.dart';
import '../widgets/spotifybutton.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  static late int _startTime;
  static int _currentTime = 0;
  static int _currentSpeed = 10;
  static bool _isRunning = false;
  static bool _showDog = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.value = 1.0;
    if (_isRunning){
      _currentTime = DateTime.now().millisecondsSinceEpoch - _startTime;
      Timer.periodic(
        const Duration(seconds: 1),
            (timer) {
          if (mounted) {
            setState(
                  () {
                _currentTime = DateTime.now().millisecondsSinceEpoch - _startTime;
              },
            );
          }
        },
      );
    }
  }

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
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              sessionDisplay(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              speedSelector(),
              startRunButton(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
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
            title: Text(DateFormat('HH:mm:ss')
                .format(DateTime.fromMillisecondsSinceEpoch(_currentTime)),
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
        innerWidget: (double value) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return _showDog
                  ? FadeTransition(
                      opacity: _animation,
                      child: Image.asset("assets/images/jogging_dog.gif",
                          scale: 1.5),
                    )
                  : FadeTransition(
                      opacity: _animation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "$_currentSpeed km/h",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          Text(
                            'Select speed',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    );
            },
          );
        },
        appearance: CircularSliderAppearance(
          size: MediaQuery.of(context).size.height * 0.4,
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
        ),
        min: 5,
        max: 20,
        initialValue: _currentSpeed.toDouble(),
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
      height: MediaQuery.of(context).size.height * 0.05,
      width: double.infinity,
      child: _isRunning
          ? ElevatedButton(
              child: const Text("Stop Run"),
              onPressed: () {
                setState(
                  () {
                    _isRunning = !_isRunning;
                    stopPressed();
                    _animationController.reverse().then((_) {
                      _showDog = !_showDog;
                      _animationController.forward();
                    });
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
                    startPressed();
                    _animationController.reverse().then((_) {
                      _showDog = !_showDog;
                      _animationController.forward();
                    });
                  },
                );
              },
            ),
    );
  }

  void startPressed() {
    _currentTime = 0;
    _startTime = DateTime.now().millisecondsSinceEpoch;
    Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (mounted) {
          setState(
                () {
              _currentTime = DateTime.now().millisecondsSinceEpoch - _startTime;
            },
          );
        }
      },
    );
    RunMusicLogic().startRun(_currentSpeed.toDouble(), 1);
  }

  void stopPressed() {
    RunMusicLogic().finishRun();
  }
}
