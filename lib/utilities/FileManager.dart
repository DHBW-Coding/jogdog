import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jog_dog/utilities/debugLogger.dart' as logger;
import 'package:path_provider/path_provider.dart';

class FileManager {
  static final FileManager _instance = FileManager._internal();

  factory FileManager() {
    return _instance;
  }

  FileManager._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> savetoJson(String fileName, Map<String, dynamic> object) async {

    final path = await _localPath;
    final file = File('$path/$fileName.json');

    String contents = '';
    Map<String, dynamic> container = {};

    try {
      contents = await file.readAsString();
      if(kDebugMode) logger.dataLogger.i("Read file: $contents");
    } catch (e) {
      if(kDebugMode) logger.dataLogger.e("Error while reading file: $e");
    }

    try {
      if (contents.isNotEmpty) {
        container = jsonDecode(contents);
        if(kDebugMode) logger.dataLogger.i("Decoded json: $container");
      }
    } catch (e) {
      if(kDebugMode) logger.dataLogger.e("Error while decoding json: $e");
    }

    container.addAll(object);

    String toWrite = '';

    try {
      toWrite = jsonEncode(container);
      if(kDebugMode) logger.dataLogger.i("Encoded to json: $toWrite");
    } catch (e) {
      if(kDebugMode) logger.dataLogger.e("Error while encoding to json: $e");
    }

    try {
      if (await file.exists()) {
        if(kDebugMode) logger.dataLogger.i("File exists, writing to file: $toWrite");
        return file.writeAsString(toWrite);
      } else {
        if(kDebugMode) logger.dataLogger.i("File does not exist, creating file and writing to file: $toWrite");
        return file.create().then((value) => file.writeAsString(toWrite));
      }
    } catch (e) {
      if(kDebugMode) logger.dataLogger.e("Error while writing to file: $e");
      return Future.error(e);
    }
  }

}