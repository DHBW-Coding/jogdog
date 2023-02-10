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
        Expanded(
          child: Card(
            child: SizedBox(
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("Time run: ${widget.currentTime}"))),
          ),
        ),
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
