import 'package:jog_dog/utilities/settings_file_manager.dart';

class Settings {

  static final Settings _settings = Settings._internal();
  String _theme = "Dark";
  String get theme => _theme;
  double _tolerance = 0.05;
  double get tolerance => _tolerance;

  Settings._internal();

  factory Settings() {
    return _settings;
  }

  /// Sets the tolerance for the jog dog
  void setTolerance(double tolerance) {
    if (tolerance > 1) {
      return;
    }
    _tolerance = tolerance;
    SettingsFileManager().saveSettings(this);
  }

  /// Sets the theme for the jog dog
  void setTheme(String theme) {
    _theme = theme;
    SettingsFileManager().saveSettings(this);
  }

  /// Creates a settings object from a json map
  Settings.fromJson(Map<String, dynamic> json) {
    _theme = json['theme'];
    _tolerance = json['tolerance'];
  }

  /// Creates a json map from a settings object
  Map<String, dynamic> toJson() {
    return {
      'theme': _theme,
      'tolerance': _tolerance,
    };
  }

}