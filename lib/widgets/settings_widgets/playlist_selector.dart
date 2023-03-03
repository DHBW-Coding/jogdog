import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/local_music_controller.dart';
import 'package:jog_dog/utilities/debug_logger.dart' as logger;

class PlaylistSelector extends StatefulWidget {
  const PlaylistSelector({super.key});

  @override
  PlaylistSelectorState createState() => PlaylistSelectorState();
}

class PlaylistSelectorState extends State<PlaylistSelector> {
  static bool _musicIsLoaded = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _musicIsLoaded
          ? Text(
              localMusicController().getSelectedPlaylistName(),
              style: const TextStyle(fontStyle: FontStyle.italic),
            )
          : const Text("Select Playlist"),
      leading: const Icon(Icons.my_library_music_outlined),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () async {
        _musicIsLoaded = await localMusicController().loadMusic();
        setState(() {
          logger.allLogger.i("MusicIsLoaded: $_musicIsLoaded");
        });
      },
    );
  }
}
