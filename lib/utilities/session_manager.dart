import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:jog_dog/utilities/run_music_logic.dart';
import 'package:jog_dog/utilities/debugLogger.dart' as logger;
import 'package:jog_dog/utilities/session_file_manager.dart';
import 'package:uuid/uuid.dart';

class Session {

  String _id = const Uuid().v4();
  String get id => _id;
  Map<int, double> _speeds = {};
  late int _runStarted;
  late int _runEnded;

  Session();

  /// Returns the runtime of the session as a string
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'runStarted': _runStarted,
      'runEnded': _runEnded,
      'speeds': _speeds.toString(),
    };
  }

  /// Returns a session from a json map
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session()
      .._id = json['id']
      .._runStarted = json['runStarted']
      .._runEnded = json['runEnded']
      .._speeds = json['speeds'];
  }

}

class SessionManager {

  static final SessionManager _instance = SessionManager._internal();
  late List<Session> _sessions = [];
  List<Session> get sessions => _sessions;
  late Session _currentSession;
  late StreamSubscription _subscription;
  bool _isRunning = false;
  int _sessionCount = 0;

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  /// Loads all sessions from the local storage
  void loadSessionsFromJson() {
    _sessions = SessionFileManager().loadAllSessions() as List<Session>;
    _sessionCount = _sessions.length;
  }

  /// Creates a new session and starts tracking
  void createNewSession() {
    _currentSession = Session();
    var time = DateTime.now().millisecondsSinceEpoch;
    _currentSession._runStarted = time;
    _currentSession._runEnded = time;
    if(kDebugMode) logger.dataLogger.v("Session started at ${DateTime.now().microsecondsSinceEpoch}");
    continueSessionTracking();
  }

  /// Starts tracking the current session
  void continueSessionTracking() {
    if (_isRunning) { return; }
    _isRunning = true;
    _saveSessionPeriodically();
    _subscription = SensorData().normelizedSpeedStream.listen((double speed) {
      var time = DateTime.now().millisecondsSinceEpoch;
      _currentSession._speeds[time] = speed;
      _currentSession._runEnded = time;
      if(kDebugMode) {
        logger.dataLogger.v("Runtime: ${getRunTimeAsString(_currentSession)}, "
          "Top Speed: ${getTopSpeed(_currentSession)}, "
          "Average Speed: ${getAverageSpeed(_currentSession)}, "
          "Timestamp: ${DateTime.now().millisecondsSinceEpoch}");
      }
    });
  }

  /// Pauses tracking the current session
  void pauseSessionTracking() {
    if (!_isRunning) { return; }
    _isRunning = false;
    _subscription.cancel();
  }

  /// Stops tracking the current session
  void stopSessionTracking(bool keep) {
    if (!_isRunning) { return; }
    _isRunning = false;
    _subscription.cancel();
    _saveSession();
    keepSessionAtEndOfRun(keep);
  }

  /// Saves the current session to the local storage
  void _saveSession() {
    SessionFileManager().saveSession(_currentSession);
  }

  /// Deletes the session with the given id
  void deleteSession(String id) {
    SessionFileManager().deleteSession(id);
  }

  /// Deletes all sessions
  void deleteAllSessions() {
    SessionFileManager().deleteAllSessions();
  }

  /// Saves the current session to the local storage periodically
  void _saveSessionPeriodically() {
    if (!_isRunning) { return; }
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if(!_isRunning) { timer.cancel(); }
      _saveSession();
      });
  }

  /// Saves the current session or deletes it
  void keepSessionAtEndOfRun(bool keep) {
    if (keep) {
      if (_sessionCount > 49) {
        /*
        *  TODO: Show dialog to ask if the user wants to delete oldest sessions
        *  TODO: If yes, delete the oldest session and save the current one
        */
        return;
      }
      _saveSession();
      _sessionCount++;
      loadSessionsFromJson();
    } else {
      deleteSession(_currentSession.id);
    }
  }

  /// Returns the run time of the session as a string
  double getRunTime(Session session) {
    return (session._runEnded - session._runStarted)/1000;
  }

  /// Returns the top speed of the session
  double getTopSpeed(Session session) {
    double currentMaximum = 0;
    if (session._speeds.isNotEmpty) {
      session._speeds.forEach((key, value) {
        if (value > currentMaximum) {
          currentMaximum = value;
        }
      });
    }
    return currentMaximum;
  }

  /// Returns the average speed of the session
  double getAverageSpeed(Session session) {
    double sum = 0;
    if (session._speeds.isNotEmpty) {
      session._speeds.forEach((key, value) { sum += value; });
      return sum / session._speeds.length;
    }
    return 0;
  }

  /// Returns the run time of the session as a string
  String getRunTimeAsString(Session session) {
    double runTime = (session._runEnded - session._runStarted)/1000;
    double hours = runTime / 3600;
    double minutes = (runTime - hours * 3600) / 60;
    double seconds = runTime - hours * 3600 - minutes * 60;
    return "${hours.floor()}:${minutes.floor()}:${seconds.floor()}";
  }

  /// Returns the start time of the session as a string
  String getStartTimeAsString(Session session) {
    return DateFormat('HH:mm:ss  dd:MM:yyyy').format(DateTime.fromMillisecondsSinceEpoch(session._runStarted));
  }

  /// Returns the end time of the session as a string
  String getEndTimeAsString(Session session) {
    return DateFormat('HH:mm:ss  dd:MM:yyyy').format(DateTime.fromMillisecondsSinceEpoch(session._runEnded));
  }

}
