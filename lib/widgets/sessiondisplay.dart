import 'package:flutter/material.dart';

class SessionDisplay extends StatelessWidget {
  const SessionDisplay({super.key});

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
              child: const Center(
                child: Text("Display Timer time"),
              )),
        )
      ],
    );
  }
}
