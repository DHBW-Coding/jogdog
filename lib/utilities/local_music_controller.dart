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
  bool _isPlaylistSet = false;
  bool get isPlaylistSet => _isPlaylistSet;
  bool get isMusicLoaded => _isMusicLoaded;
  List<String> songPath = [];
  late AudioPlayer player;
  String directoryPath = Settings().musicPath;
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
  Future<void> setNewPlaylistDir() async {
    String? temp = await FilePicker.platform.getDirectoryPath();
    if (temp == "/" || temp == null) {
      directoryPath = "";
    } else {
      directoryPath = temp.toString();
      Settings().setMusicPath(directoryPath);
      _isPlaylistSet = true;
    }
  }

  /// Returns a List which includes all paths to the files in the directory [path]
  Future<void> loadMusicFromPath() async {
    Directory dir = Directory(directoryPath);
    if (!await dir.exists()) {
      return;
    }

    List<String> songs = [];
    if (await dir.exists()) {
      songs = dir
        .listSync()
        .whereType<File>()
        .map((entity) => entity.path)
        .toList();
    }

    ConcatenatingAudioSource playlist =
    ConcatenatingAudioSource(children: []);

    for (var song in songs) {
      if (song.endsWith(".mp3") || song.endsWith(".wav")) {
        playlist.add(AudioSource.file(song));
      }
      if (playlist.length == 200) {
        break;
      }
    }

    if (playlist.length == 0) {
      logger.dataLogger.i("No Song was found in Folder $directoryPath");
    } else {
      _isMusicLoaded = true;
      logger.dataLogger
          .i("${playlist.length - 5} Songs were added to the playlist");
    }

    player.setAudioSource(playlist);
    _isMusicLoaded = true;
  }

  /// Returns the Name of the Folder used
  String getSelectedPlaylistName() {
    int indexOfLastDirSlash = directoryPath.lastIndexOf("/");
    return directoryPath.substring(indexOfLastDirSlash + 1);
  }

  /// loads the music/playlist to be played
  @override
  Future<void> loadMusic() async {
    await player.setLoopMode(LoopMode.all);

    // writes all files from [directoyPath] into songPath
    if (directoryPath.isNotEmpty) {
      await loadMusicFromPath();
    } else {
      loadDefaultPlaylist();
    }
    _isMusicLoaded = true;
  }

  /// Loads the Default Songs
  void loadDefaultPlaylist() {
    ConcatenatingAudioSource defaultPlaylist =
        ConcatenatingAudioSource(children: [
      AudioSource.asset("assets/music/Different_Heaven.mp3"),
      AudioSource.asset("assets/music/Disfigure_Blank.mp3"),
      AudioSource.asset("assets/music/Invincible.mp3"),
      AudioSource.asset("assets/music/Itro_Tobu_Cloud_9.mp3"),
      AudioSource.asset("assets/music/Tobu_Hope.mp3"),
    ]);
    player.setAudioSource(defaultPlaylist);
    _isMusicLoaded = true;
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
