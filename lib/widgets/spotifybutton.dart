import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/local_music_controller.dart';

/// Button to connect to the music
class SpotifyButton extends StatefulWidget {
  const SpotifyButton({super.key});

  @override
  SpotifyButtonState createState() => SpotifyButtonState();
}

class SpotifyButtonState extends State<SpotifyButton>
    with SingleTickerProviderStateMixin {
  bool _isMusicLoaded = localMusicController().isMusicLoaded;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _isMusicLoaded
            ? FadeTransition(
                opacity: _animation,
                child: const SpotifyCard(),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.045,
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Load Music"),
                  onPressed: () {
                    _animationController.forward();
                    setState(
                      () {
                        _isMusicLoaded = true;
                      },
                    );
                  },
                ),
              );
      },
    );
  }
}

class SpotifyCard extends StatefulWidget {
  const SpotifyCard({super.key});

  @override
  SpotifyCardState createState() => SpotifyCardState();
}

class SpotifyCardState extends State<SpotifyCard> {
  static bool _isMusicPlaying = false;

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
                        localMusicController().previous();
                      },
                    ),
                    IconButton(
                      icon: Icon(_isMusicPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        setState(() {
                          _isMusicPlaying = !_isMusicPlaying;
                        });
                        localMusicController().togglePlayState();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        localMusicController().skip();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
