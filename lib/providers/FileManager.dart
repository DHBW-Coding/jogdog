import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:jog_dog/utilities/debugLogger.dart' as logger;
import 'package:path_provider/path_provider.dart';

abstract class FileManager {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<List<String>> listFiles(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory('${directory.path}/$path');
    List<String> files = [];
    try {
      files = dir.listSync().map((e) => e.path).toList();
    } catch (e) {
      if(kDebugMode) {
        print(e);
        logger.dataLogger.e("Error while listing files: $e");
      }
    }
    return files;
  }

  Future<Map<String, dynamic>> loadFromJson(String name) async {
    final path = await _localPath;
    final file = File('$path/$name.json');
    String contents = '';
    Map<String, dynamic> container = {};
    try {
      contents = await file.readAsString();
      if(kDebugMode) logger.dataLogger.i("Read file: $contents");
    } catch (e) {
      if (kDebugMode) {
        print(e);
        logger.dataLogger.e("Error while reading file: $e");
      }
    }
    try {
      if (contents.isNotEmpty) {
        container = jsonDecode(contents);
        if(kDebugMode) logger.dataLogger.i("Decoded json: $container");
      }
    } catch (e) {
      if(kDebugMode) {
        print(e);
        logger.dataLogger.e("Error while decoding json: $e");
      }
    }
    return container;
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
      if (kDebugMode) {
        print(e);
        logger.dataLogger.e("Error while reading file: $e");
      }
    }
    try {
      if (contents.isNotEmpty) {
        container = jsonDecode(contents);
        if(kDebugMode) logger.dataLogger.i("Decoded json: $container");
      }
    } catch (e) {
      if(kDebugMode) {
        print(e);
        logger.dataLogger.e("Error while decoding json: $e");
      }
    }
    container.addAll(object);
    String toWrite = '';
    try {
      toWrite = jsonEncode(container);
      if(kDebugMode) logger.dataLogger.i("Encoded to json: $toWrite");
    } catch (e) {
      if(kDebugMode) {
        print(e);
        logger.dataLogger.e("Error while encoding to json: $e");
      }
    }
    try {
      if (await file.exists()) {
        if(kDebugMode) logger.dataLogger.i("File exists, writing to file: $toWrite");
        return file.writeAsString(toWrite);
      } else {
        if(kDebugMode) logger.dataLogger.i("File does not exist, creating file and writing to file: $toWrite");
        return file.create(recursive: true).then((value) => file.writeAsString(toWrite));
      }
    } catch (e) {
      if(kDebugMode) {
        logger.dataLogger.e("Error while writing to file: $e");
        print(e);
      }
      return Future.error(e);
    }
  }

}