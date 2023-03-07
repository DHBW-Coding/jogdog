import 'package:jog_dog/utilities/settings_file_manager.dart';

class Settings {

  static Settings _settings = Settings._internal();
  double _tolerance = 0.05;
  double get tolerance => _tolerance;
  int _targetSpeed = 10;
  int get targetSpeed => _targetSpeed;
  String _musicPath = "/";
  String get musicPath => _musicPath;

  Settings._internal(){
    loadSettings();
  }

  factory Settings() {
    return _settings;
  }

  Future loadSettings() async {
    _settings = await SettingsFileManager().loadSettings();
  }

  /// Sets the tolerance for the jog dog
  void setTolerance(double tolerance) {
    if (tolerance > 1) {
      return;
    }
    _tolerance = tolerance;
    SettingsFileManager().saveSettings(this);
  }

  /// Sets the target speed for the jog dog
  void setTargetSpeed(int targetSpeed) {
    _targetSpeed = targetSpeed;
    SettingsFileManager().saveSettings(this);
  }

  void setMusicPath(String musicPath) {
    _musicPath = musicPath;
    SettingsFileManager().saveSettings(this);
  }

  /// Creates a settings object from a json map
  Settings.fromJson(Map<String, dynamic> json) {
    _tolerance = json['tolerance'];
    _targetSpeed = json['targetSpeed'];
    _musicPath = json['musicPath'];
  }

  /// Creates a json map from a settings object
  Map<String, dynamic> toJson() {
    return {
      'tolerance': _tolerance,
      'targetSpeed': _targetSpeed,
      'musicPath': _musicPath,
    };
  }

  void load() {
    //idk what to do here I just want to make sure the settings are loaded
  }
}