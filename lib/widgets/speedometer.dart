import 'package:flutter/material.dart';

/// Widget that displays the speed the user is jogging 
/// as well as selecting the users targeted speed
class Speedometer extends StatelessWidget {
  Speedometer({super.key, required double speedValue}) {
    _currentSpeed = speedValue;
  }

  double _currentSpeed = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)),
          child: SizedBox(
              width: 300,
              height: 300,
              child: Center(
                child: Text(
                  "${_currentSpeed.round()} km/h",
                  style: Theme.of(context).textTheme.headline2,
                ),
              )),
        ),
      ],
    );
  }
}
