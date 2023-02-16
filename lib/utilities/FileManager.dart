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
    if(kDebugMode) logger.dataLogger.v("Path: $path");
    if (await file.exists()) {
      return file.writeAsString(jsonEncode(object));
    } else {
      String contents = await file.readAsString();
      Map<String, dynamic> container = jsonDecode(contents);
      container.addAll(object);
      return file.create().then((value) => file.writeAsString(jsonEncode(object)));
    }
  }

}