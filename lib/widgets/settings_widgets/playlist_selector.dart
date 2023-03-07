import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/local_music_controller.dart';
import 'package:jog_dog/utilities/debug_logger.dart' as logger;

class PlaylistSelector extends StatefulWidget {
  const PlaylistSelector({super.key});

  @override
  PlaylistSelectorState createState() => PlaylistSelectorState();
}

class PlaylistSelectorState extends State<PlaylistSelector> {
  bool _isPlaylistSet = localMusicController().isPlaylistSet;
  String selectedPlaylistName = localMusicController().getSelectedPlaylistName();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _isPlaylistSet
          ? Text(
              "Playlist selected: $selectedPlaylistName")
          : const Text("Select playlist"),
      leading: const Icon(Icons.my_library_music_outlined),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () async {
        await localMusicController().setNewPlaylistDir();
        await localMusicController().loadMusic();
        setState(() {
          _isPlaylistSet = localMusicController().directoryPath.isNotEmpty;
          selectedPlaylistName = localMusicController().getSelectedPlaylistName();
          logger.allLogger.i("Playlist has been set: $_isPlaylistSet");
        });
      },
    );
  }
}
