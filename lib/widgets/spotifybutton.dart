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
  final bool _isMusicLoaded = localMusicController().isMusicLoaded;

  @override
  Widget build(BuildContext context) {
        if(_isMusicLoaded) {
          return Column(
            children: const [
              Divider(),
              SpotifyCard(),
            ]
          );
        }
        return const SizedBox();
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
    return Padding(
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
    );
  }
}
