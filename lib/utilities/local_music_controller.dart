import 'dart:io';
import 'package:jog_dog/utilities/debug_logger.dart' as logger;

import 'package:jog_dog/providers/music_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';

class localMusicController implements MusicInterface {
  bool isPlaying = false;
  Duration songTime = Duration.zero;
  bool musicIsLoaded = false;
  List<String> songPath = [];
  late AudioPlayer player;
  late String directoryPath;
  static final localMusicController _instance =
      localMusicController._internal();

  factory localMusicController() {
    return _instance;
  }

  localMusicController._internal() {
    player = AudioPlayer();
    directoryPath = "";
  }

  /// set the replay-speed for the current song
  @override
  void setPlaybackSpeed(double changeFactor) async {
    if (0 < changeFactor && changeFactor <= 2) {
      await player.setSpeed(changeFactor);
    } else {
      logger.dataLogger.v('Change factor was out of range');
    }
  }

  /// lets the user choose the folder who´s files get put into the Playlist
  /// path to this folder is stored in [directoryPath]
  Future<String> getPlaylistDir() async {
    String? temp = await FilePicker.platform.getDirectoryPath();
    if (temp == "/" || temp == null) {
      directoryPath = "/";
    } else {
      directoryPath = temp.toString();
    }
    return directoryPath;
  }

  Future<List<String>> loadMusicFromPath(String path) async {
    Directory directory = Directory(directoryPath);
    return await directory.list().listen(
      (event) {
        songPath.add(event.path);
      },
    ).asFuture(songPath);
  }

  String getSelectedPlaylistName() {
    int indexOfLastDirSlash = directoryPath.lastIndexOf("/");
    return directoryPath.substring(indexOfLastDirSlash + 1);
  }

  /// loads the music/playlist to be played
  @override
  Future<bool> loadMusic() async {
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: [
      AudioSource.asset("assets/music/Different_Heaven.mp3"),
      AudioSource.asset("assets/music/Disfigure_Blank.mp3"),
      AudioSource.asset("assets/music/Incincible.mp3"),
      AudioSource.asset("assets/music/Itro_Tobu_Cloud_9.mp3"),
      AudioSource.asset("assets/music/Tobu_Hope.mp3"),
    ]);
    directoryPath = await getPlaylistDir();

    if (directoryPath == "/") {
      songPath = ["No Song was found"];
      logger.allLogger.i("No Song was found.");
      player.setAudioSource(playlist);
      return true;
    }

    await loadMusicFromPath(directoryPath);

    for (var element in songPath) {
      if (element.endsWith(".mp3") || element.endsWith(".wav")) {
        playlist.add(AudioSource.file(element));
      }
      if (playlist.length == 200) {
        break;
      }
      logger.dataLogger
          .i("${playlist.length - 5} Songs were added to the playlist");
    }
    if ((playlist.length - 5) > 0) {
      playlist.removeAt(0);
      playlist.removeAt(1);
      playlist.removeAt(2);
      playlist.removeAt(3);
      playlist.removeAt(4);
    } else {
      logger.dataLogger.i("No Song was found in Folder $directoryPath");
    }

    player.setAudioSource(playlist);
    musicIsLoaded = true;
    return true;
  }

  /// Toggles the isPlaying variable
  @override
  void togglePlayState() {
    if (isPlaying) {
      player.pause();
    } else {
      player.play();
    }
    isPlaying = !isPlaying;
  }

  @override
  void setSongTime(Duration time) {
    player.seek(time);
  }

  @override
  void skip() {
    player.seekToNext();
  }

  @override
  void previous() {
    player.seekToPrevious();
  }
}
