import 'dart:async';
import 'package:flutter/material.dart';

class SessionDisplay extends StatefulWidget {
  SessionDisplay({super.key});

  int currentTime = 0;

  @override
  _SessionDisplay createState() => _SessionDisplay();
}

class _SessionDisplay extends State<SessionDisplay> {
  late bool _isRunning = false;
  final Duration _duration = const Duration();
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
          widget.currentTime++;
        });
      });
      setState(() {
        _isRunning = true;
      });
    }
  }
}
