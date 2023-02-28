import 'dart:async';

import 'package:flutter/material.dart';

/// Widget that displays the current Time since the Session started
class SessionDisplay extends StatefulWidget {
  SessionDisplay({super.key});

  int currentTime = 0;

  @override
  SessionDisplayState createState() => SessionDisplayState();
}

class SessionDisplayState extends State<SessionDisplay> {
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
              height: 60,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "${widget.currentTime ~/ 60}:${widget.currentTime % 60}",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                )
              ),
            ),
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
