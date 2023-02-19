import 'package:flutter/material.dart';
import 'package:jog_dog/providers/music_interface.dart';
import 'package:jog_dog/widgets/spotifybutton.dart';
import 'package:jog_dog/widgets/sessiondisplay.dart';
import 'package:jog_dog/widgets/speedometer.dart';
import 'package:jog_dog/widgets/startsessionbutton.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title, required this.musicController});

  final String title;
  final MusicInterface musicController;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SessionDisplay(),
              const SizedBox(
                height: 15,
              ),
              Speedometer(isStarted: false),
              const StartSessionButton(currentSliderValue: 5),
              const SizedBox(
                height: 15,
              ),
              SpotifyButton(musicController: widget.musicController,),
            ],
          ),
        ),
      ),
    );
  }
}
