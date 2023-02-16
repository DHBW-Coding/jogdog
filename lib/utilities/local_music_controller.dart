import 'package:jog_dog/utilities/debugLogger.dart' as logger;

import 'package:jog_dog/providers/music_interface.dart';
import 'package:just_audio/just_audio.dart';

class localMusicController implements MusicInterface {
  bool isPlaying = false;
  Duration songTime = Duration.zero;
  late AudioPlayer player;

  localMusicController(){
    player = AudioPlayer();
  }

  /// set the replay-speed for the current song
  @override
  void setPlaybackSpeed(double changeFactor) async {
    if (0 < changeFactor && changeFactor <= 2) {
      await player.setSpeed(changeFactor);
    }else{
      logger.dataLogger.v('Change factor was out of range');
    }
  }

  /// loads the music to be played
  @override
  void loadMusic() async{
    await player.setAsset('assets/music/TheColumbines.mp3');
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
  void skip(){
    player.seekToNext();
  }

  @override
  void previous(){
    player.seekToPrevious();
  }
}
