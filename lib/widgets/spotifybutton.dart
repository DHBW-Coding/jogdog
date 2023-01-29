import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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

class SpotifyCard extends StatelessWidget {
  const SpotifyCard({super.key});

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
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ));
  }
}
