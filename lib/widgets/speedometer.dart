import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../main.dart';
import '../theme/theme.dart';

class Speedometer extends StatelessWidget {
  Speedometer({
    super.key,
  });

  final ThemeMode theme = ThemeMode.system;

  late int _currentSpeed = 10;

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        size: 300,
        customColors: CustomSliderColors(
          progressBarColor: theme == ThemeMode.dark
              ? AppTheme.darkTheme.primaryColor
              : AppTheme.lightTheme.primaryColor,
          trackColor: theme == ThemeMode.dark
              ? AppTheme.darkTheme.highlightColor
              : AppTheme.lightTheme.highlightColor,
          dotColor: theme == ThemeMode.dark
              ? AppTheme.darkTheme.primaryColor
              : AppTheme.lightTheme.primaryColor,
        ),
        customWidths: CustomSliderWidths(
          progressBarWidth: 20,
          trackWidth: 20,
          handlerSize: 20,
          shadowWidth: 0,
        ),
        infoProperties: InfoProperties(
          mainLabelStyle: const TextStyle(
            color: Colors.blue,
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
        if(kDebugMode){
          logger.i("Speed: $value\n"
              "Current Speed Displayed: $_currentSpeed");
        }
      },
    );
  }
}
