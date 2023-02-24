import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jog_dog/utilities/debug_Logger.dart' as logger;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

abstract class FileManager {
  /// Returns the path to the application documents directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Returns a list of all files in the given path
  /// The path must be relative to the application documents directory
  /// Example: listFiles("Sessions")
  Future<List<String>> listFiles(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory('${directory.path}/$path');
    List<String> files = [];
    if (await dir.exists()){
      files = dir
          .listSync()
          .whereType<File>()
          .map((entity) => basenameWithoutExtension(entity.path))
          .toList();
    }
    return files;
  }

  /// Loads a json file from the local storage and returns a map
  /// The map is empty if the file does not exist or is empty
  /// If the file is located in a Subfolder, the path must be given as well
  /// Example: loadFromJson("Sessions/1234")
  Future<Map<String, dynamic>> loadFromJson(String filePath) async {
    final path = await _localPath;
    final file = File('$path/$filePath.json');
    String contents = '';
    Map<String, dynamic> container = {};
    if (await file.exists()) {
      contents = await file.readAsString();
      if (contents.isNotEmpty) {
        container = jsonDecode(contents);
        if (kDebugMode) logger.dataLogger.i("Decoded json: $container");
      }
    }
    return container;
  }

  /// Saves a map to a json file in the local storage
  /// If the file already exists, the map will be added to the existing map
  /// If the file is located in a Subfolder, the path must be given as well
  /// Example: savetoJson("Sessions/1234", {"key": "value"})
  Future<File> savetoJson(String filePath, Map<String, dynamic> object) async {
    final path = await _localPath;
    final file = File('$path/$filePath.json');
    String contents = '';
    Map<String, dynamic> container = {};
    if (await file.exists()) {
      contents = await file.readAsString();
      if (contents.isNotEmpty) {
        container = jsonDecode(contents);
        if (kDebugMode) logger.dataLogger.i("Decoded json: $container");
      }
    }
    container.addAll(object);
    String toWrite = '';
    toWrite = jsonEncode(container);

    try {
      if (await file.exists()) {
        if (kDebugMode) {
          logger.dataLogger.i("File exists, writing to file: $toWrite");
        }
        return file.writeAsString(toWrite);
      } else {
        if (kDebugMode) {
          logger.dataLogger.i(
              "File does not exist, creating file and writing to file: $toWrite");
        }
        return file
            .create(recursive: true)
            .then((value) => file.writeAsString(toWrite));
      }
    } catch (e) {
      /// If an error occurs, because there is no space left on the device
      /// the error is caught and the user is informed
      if (e.toString().contains("No space left on device")) {
        /// TODO: Show error message to the user
        /// TODO: Show user the option to delete old files to free up space
      }

      if (kDebugMode) {
        logger.dataLogger.e("Error while writing to file: $e");
        print(e);
      }
      return Future.error(e);
    }
  }

  /// Deletes a file from the local storage
  /// The file ending must be given as well
  /// If the file is located in a Subfolder, the path must be given as well
  /// If the file does not exist, nothing happens
  /// Example: deleteFile("Sessions/1234")
  Future<void> deleteFile(String filePath) async {
    final path = await _localPath;
    final file = File('$path/$filePath');
    if (await file.exists()) {
      file.delete();
      if (kDebugMode) {
        logger.dataLogger.i("File exists, deleting file: $filePath");
      }
    } else {
      if (kDebugMode) {
        logger.dataLogger.i("File does not exist, nothing to delete");
      }
    }
  }
}
