import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../theme/theme.dart';

class Speedometer extends StatelessWidget {
  Speedometer({
    super.key,
  });

  ThemeMode theme = ThemeMode.system;

  late int _currentSpeed = 5;

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
            return value.toInt().toString();
          },
        ),
      ),
      min: 1,
      max: 15,
      initialValue: _currentSpeed.toDouble(),
      onChange: (double value) {
        _currentSpeed = value.toInt();
      },
    );
  }
}
