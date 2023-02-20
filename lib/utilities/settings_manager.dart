import 'package:jog_dog/utilities/settings_file_manager.dart';

class Settings {

  String _theme = "Dark";
  double _tolerance = 0.05;

  Settings();

  Settings.fromJson(Map<String, dynamic> json) {
    _theme = json['theme'];
    _tolerance = json['tolerance'];
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': _theme,
      'tolerance': _tolerance,
    };
  }

}

class SettingsManager {

  static final SettingsManager _instance = SettingsManager._internal();
  late Settings _settings;

  factory SettingsManager() {
    return _instance;
  }

  SettingsManager._internal() {
    _settings = SettingsFileManager().loadSettings() as Settings;
  }

  void changeTolerance(double tolerance) {
    _settings._tolerance = tolerance;
    SettingsFileManager().saveSettings(_settings);
  }

  void changeTheme(String theme) {
    _settings._theme = theme;
    SettingsFileManager().saveSettings(_settings);
  }

}