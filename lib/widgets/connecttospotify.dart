import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConnectToSpotify extends StatelessWidget {
  const ConnectToSpotify({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 315,
      height: 50,
      child: ElevatedButton(
        child: const Text("Connect to Spotify"),
        onPressed: () {},
      ),
    );
  }
}
