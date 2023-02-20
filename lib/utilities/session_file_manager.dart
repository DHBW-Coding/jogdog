import 'package:jog_dog/utilities/session_manager.dart';

import '../providers/FileManager.dart';

class SessionFileManager extends FileManager {

  static final SessionFileManager _instance = SessionFileManager._internal();

  factory SessionFileManager() {
    return _instance;
  }

  SessionFileManager._internal();

  Future<void> saveSession(Session session) async {
    await savetoJson("Sessions/${session.id}", session.toJson());
  }

  Future<Session> loadSessions(String id) async {
    return Session.fromJson(await loadFromJson("Sessions/$id"));
  }

  Future<List<Session>> loadAllSessions() async {
    List<Session> sessions = [];
    List<String> sessionIds = await listFiles("Sessions");
    for (String id in sessionIds) {
      sessions.add(await loadSessions(id));
    }
    return sessions;
  }

}