import 'dart:async';
import 'package:flutter/material.dart';


/// Widget that displays the current Time since the Session started
class SessionDisplay extends StatefulWidget {
  SessionDisplay({super.key});

  int currentTime = 0;

  @override
  _SessionDisplay createState() => _SessionDisplay();
}

class _SessionDisplay extends State<SessionDisplay> {
  late int _time = 0;
  late bool _isRunning = false;
  final Duration _duration = Duration();
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: Container(
              width: 315,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(child: Text(widget.currentTime.toString()))),
        )
      ],
    );
  }

  void handleTimer() {
    if (_isRunning) {
      _timer.cancel();
      setState(() {
        _isRunning = false;
      });
    } else {
      _timer = Timer.periodic(_duration, (timer) {
        setState(() {
          _time++;
        });
      });
      setState(() {
        _isRunning = true;
      });
    }
  }
}
