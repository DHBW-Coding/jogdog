import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:jog_dog/utilities/debug_Logger.dart' as logger;

import 'package:jog_dog/providers/music_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';


class localMusicController implements MusicInterface  {
  bool isPlaying = false;
  Duration songTime = Duration.zero;
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
  Future<String> getPlaylistDir()async{
    String? temp  = await FilePicker.platform.getDirectoryPath();
    if(temp == "/" || temp == null){
      directoryPath = "/";
    }else{
      directoryPath = temp.toString();
    }
    return directoryPath;
  }


  Future<List<String>> loadMusicFromPath(String path)async {

    Directory directory = Directory(directoryPath);
    return await directory.list().listen((event) {
      songPath.add(event.path);
    },).asFuture(songPath);

  }

  /// loads the music/playlist to be played
  @override
  void loadMusic() async {
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: [AudioSource.asset("assets/music/SFG.mp3")]);
    directoryPath = await getPlaylistDir();

    

    if(directoryPath == "/"){
      songPath =  ["No Song was found"];
      player.setAudioSource(playlist);
      return;
    }

    await loadMusicFromPath(directoryPath);

    if(songPath.length > 200) {
      songPath = songPath.sublist(0, 200);
    }

    for(var element in songPath){
      playlist.add(AudioSource.file(element));
    }
    if(playlist.length > 1){
      playlist.removeAt(0);
    }

    player.setAudioSource(playlist);

 
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
