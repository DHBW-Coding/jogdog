
import 'package:flutter/material.dart';
import 'package:jog_dog/providers/music_interface.dart';
import 'package:jog_dog/utilities/local_music_controller.dart';




/// Button to connect to the music
class SpotifyButton extends StatefulWidget {
  SpotifyButton({super.key, required this.musicController});

  MusicInterface musicController;
  @override
  _SpotifyButtonState createState() => _SpotifyButtonState(musicController: musicController);
}

class _SpotifyButtonState extends State<SpotifyButton>
    with SingleTickerProviderStateMixin {

  _SpotifyButtonState({required this.musicController});

  bool _connected = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  MusicInterface musicController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _connected
            ? FadeTransition(
                opacity: _animation,
                child: SpotifyCard(musicController: musicController,),
              )
            : SizedBox(
                width: 315,
                child: ElevatedButton(
                  child: const Text("Load Music"),
                  onPressed: () {
                    _animationController.forward();
                    musicController.loadMusic();
                    setState(() {
                      _connected = true;
                    });
                  },
                ));
      },
    );
  }
}

class SpotifyCard extends StatelessWidget {
   SpotifyCard({super.key, required this.musicController});

   MusicInterface musicController;


  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 315,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Icon(Icons.account_balance),
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: () {
                musicController.setPlaybackSpeed(0.5);
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                  musicController.togglePlayState();
              }
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () {
                musicController.setPlaybackSpeed(1.5);
              },
            ),
          ],
        ),
      ),
    ));
  }
}
