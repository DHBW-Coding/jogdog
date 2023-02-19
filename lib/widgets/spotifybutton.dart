import 'package:flutter/material.dart';
import 'package:jog_dog/providers/music_interface.dart';
import 'package:jog_dog/utilities/local_music_controller.dart';




/// Button to connect to the music
class SpotifyButton extends StatefulWidget {
  SpotifyButton({super.key, required this.musicController});


  // Todo: MusicController anders übergeben?
  MusicInterface musicController;
  @override
  SpotifyButtonState createState() => SpotifyButtonState(musicController: musicController);
}

class SpotifyButtonState extends State<SpotifyButton>
    with SingleTickerProviderStateMixin {
  SpotifyButtonState({required this.musicController});

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
                width: double.infinity,
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
  SpotifyCardState createState() => SpotifyCardState();
}

class SpotifyCardState extends State<SpotifyCard> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Icon(Icons.music_note),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () {
                        musicController.previous();
                      },
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                        musicController.togglePlayState();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        musicController.skip();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
