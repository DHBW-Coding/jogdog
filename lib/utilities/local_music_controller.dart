import 'dart:io';
import 'package:jog_dog/utilities/debug_logger.dart' as logger;

import 'package:jog_dog/providers/music_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jog_dog/utilities/settings.dart';
import 'package:just_audio/just_audio.dart';

/// Music Controller that works with local files and which implements the [MusicInterface]
class localMusicController implements MusicInterface {
  bool isPlaying = false;
  Duration songTime = Duration.zero;
  bool _isMusicLoaded = false;

  bool get isMusicLoaded => _isMusicLoaded;
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
      Settings().setMusicPath(directoryPath);
    }
    return directoryPath;
  }

  /// Returns a List which includes all paths to the files in the directory [path]
  Future<List<String>> loadMusicFromPath(String path) async {
    Directory directory = Directory(directoryPath);
    return await directory.list().listen(
      (event) {
        songPath.add(event.path);
      },
    ).asFuture(songPath);
  }

  /// Returns the Name of the Folder used
  String getSelectedPlaylistName() {
    int indexOfLastDirSlash = directoryPath.lastIndexOf("/");
    return directoryPath.substring(indexOfLastDirSlash + 1);
  }

  /// loads the music/playlist to be played
  @override
  Future<bool> loadMusic() async {
    directoryPath = await getPlaylistDir();

    // writes all files from [directoyPath] into songPath
    await loadMusicFromPath(directoryPath);

    ConcatenatingAudioSource dynamicPlaylist =
        ConcatenatingAudioSource(children: []);

    for (var element in songPath) {
      if (element.endsWith(".mp3") || element.endsWith(".wav")) {
        dynamicPlaylist.add(AudioSource.file(element));
      }
      if (dynamicPlaylist.length == 200) {
        break;
      }
    }

    if (directoryPath == "/" || dynamicPlaylist.length == 0) {
      logger.dataLogger.i("No Song was found in Folder $directoryPath");
      ConcatenatingAudioSource defaultPlaylist =
          ConcatenatingAudioSource(children: [
        AudioSource.asset("assets/music/Different_Heaven.mp3"),
        AudioSource.asset("assets/music/Disfigure_Blank.mp3"),
        AudioSource.asset("assets/music/Incincible.mp3"),
        AudioSource.asset("assets/music/Itro_Tobu_Cloud_9.mp3"),
        AudioSource.asset("assets/music/Tobu_Hope.mp3"),
      ]);
      player.setAudioSource(defaultPlaylist);
      return true;
    } else {
      logger.dataLogger
          .i("${dynamicPlaylist.length - 5} Songs were added to the playlist");
    }

    player.setAudioSource(dynamicPlaylist);
    _isMusicLoaded = true;
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
