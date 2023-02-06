import 'package:flutter/material.dart';

class SpotifyButton extends StatefulWidget {
  const SpotifyButton({super.key});

  @override
  _SpotifyButtonState createState() => _SpotifyButtonState();
}

class _SpotifyButtonState extends State<SpotifyButton>
    with SingleTickerProviderStateMixin {
  bool _connected = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

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
                child: const SpotifyCard(),
              )
            : SizedBox(
                width: 315,
                child: ElevatedButton(
                  child: const Text("Connect to Spotify"),
                  onPressed: () {
                    _animationController.forward();
                    setState(() {
                      _connected = true;
                    });
                  },
                ));
      },
    );
  }
}

class SpotifyCard extends StatefulWidget {
  const SpotifyCard({super.key});

  @override
  _SpotifyCard createState() => _SpotifyCard();
}

class _SpotifyCard extends State<SpotifyCard> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 315,
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
