import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:jog_dog/utilities/session_manager.dart';
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

  Future<File> get _sessionFile async {
    final path = await _localPath;
    return File('$path/Sessions.json');
  }

  Future<File> saveSession(Session session) async {
    final file = await _sessionFile;
    String contents = await file.readAsString();
    Map<String, dynamic> sessions = jsonDecode(contents);
    sessions.addAll(session.toJson());
    return file.writeAsString(jsonEncode(sessions));
  }

  Future<List<Session>> getSessions() async {
    final file = await _sessionFile;
    String contents = await file.readAsString();
    Map<String, dynamic> sessions = jsonDecode(contents);
    List<Session> sessionList = [];
    sessions.forEach((key, value) {
      sessionList.add(Session.fromJson(value));
    });
    return sessionList;
  }
}