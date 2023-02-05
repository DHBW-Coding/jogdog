import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:jog_dog/utilities/session_manager.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _sessionFile async {
  final path = await _localPath;
  return File('$path/Sessions.json');
}

Future<File> saveSession(Session session) async {
  final file = await _sessionFile;



  // Write the file
  return file.writeAsString('');
}