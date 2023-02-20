import 'package:jog_dog/utilities/settings_manager.dart';

import '../providers/FileManager.dart';

class SettingsFileManager extends FileManager {
  static final SettingsFileManager _instance = SettingsFileManager._internal();

  factory SettingsFileManager() {
    return _instance;
  }

  SettingsFileManager._internal();

  /*
  * Saves the settings to the local storage
   */
  Future<void> saveSettings(Settings settings) async {
    await savetoJson("Settings", settings.toJson());
  }

  /*
  * Loads the settings from the local storage and returns a settings object
   */
  Future<Settings> loadSettings() async {
    return Settings.fromJson(await loadFromJson("Settings"));
  }

  /*
  * Deletes the settings from the local storage
   */
  Future<void> deleteSettings() async {
    await deleteFile("Settings.json");
  }
}