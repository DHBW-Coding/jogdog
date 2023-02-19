import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../main.dart';

/// Widget that displays the speed the user is jogging 
/// as well as selecting the users targeted speed
class Speedometer extends StatelessWidget {
  Speedometer({
    super.key,
    required this.isStarted,
  });
  final bool isStarted;

  late int _currentSpeed = 10;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: false,
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(
          size: 300,
          customColors: CustomSliderColors(
            progressBarColor: Theme.of(context).colorScheme.primary,
            trackColor: Theme.of(context).colorScheme.onInverseSurface,
            dotColor: Theme.of(context).colorScheme.primary,
          ),
          customWidths: CustomSliderWidths(
            progressBarWidth: 20,
            trackWidth: 20,
            handlerSize: 20,
            shadowWidth: 0,
          ),
          infoProperties: InfoProperties(
            mainLabelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 50,
            ),
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
                "Current Speed Displayed: $_currentSpeed");
          }
        },
      ),
    );
  }
}
