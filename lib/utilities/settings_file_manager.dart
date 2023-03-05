import 'package:jog_dog/utilities/settings.dart';

import '../providers/file_manager.dart';

class SettingsFileManager extends FileManager {

  /// Saves the settings to the local storage
  Future<void> saveSettings(Settings settings) async {
    await savetoJson("Settings", settings.toJson());
  }

  /// Loads the settings from the local storage and returns a settings object
  Future<Settings> loadSettings() async {
    Map<String, dynamic> json = await loadFromJson("Settings");
    if (json.isEmpty) {
      return Settings.fromJson(Settings().toJson());
    }else{
      return Settings.fromJson(json);
    }
  }

  /// Deletes the settings from the local storage
  Future<void> deleteSettings() async {
    await deleteFile("Settings.json");
  }

}