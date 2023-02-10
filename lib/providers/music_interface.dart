/// Interface class for all different musicProviders
abstract class MusicInterface {

  /// changes the speed of the playing music according to the
  /// given factor
  void setPlaybackSpeed(double musicChangeFactor);

  /// Toggles the music: play, pause 
  void togglePlayState();

  /// loads the music to be played
  void loadMusic();

  /// skips to [time] in the song 
  void setSongTime(Duration time);

  /// skips the song and plays the next one
  void skip();

  /// plays the song that came before the current one
  void previous();
}
