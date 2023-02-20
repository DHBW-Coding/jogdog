import 'package:jog_dog/utilities/session_manager.dart';

import '../providers/file_manager.dart';

class SessionFileManager extends FileManager {

  /// Saves a session to the local storage
  Future<void> saveSession(Session session) async {
    await savetoJson("Sessions/${session.id}", session.toJson());
  }

  /// Loads a session from the local storage and returns a session
  Future<Session> loadSession(String id) async {
    return Session.fromJson(await loadFromJson("Sessions/$id"));
  }

  /// Loads all sessions from the local storage and returns a list
  /// The list is empty if no sessions exist
  Future<List<Session>> loadAllSessions() async {
    List<Session> sessions = [];
    List<String> sessionIds = await listFiles("Sessions");
    for (String id in sessionIds) {
      sessions.add(await loadSession(id));
    }
    return sessions;
  }

  /// Deletes a session from the local storage
  Future<void> deleteSession(String id) async {
    await deleteFile("Sessions/$id.json");
    SessionManager().loadSessionsFromJson();
  }

  /// Deletes all sessions from the local storage
  Future<void> deleteAllSessions() async {
    List<String> sessionIds = await listFiles("Sessions");
    for (String id in sessionIds) {
      await deleteSession(id);
    }
  }

}