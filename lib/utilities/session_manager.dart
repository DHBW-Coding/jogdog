import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:jog_dog/utilities/debug_logger.dart' as logger;
import 'package:jog_dog/utilities/run_music_logic.dart';
import 'package:jog_dog/utilities/session_file_manager.dart';
import 'package:jog_dog/utilities/settings.dart';
import 'package:uuid/uuid.dart';

class Session {
  String _id = Uuid().v4();
  late int _targetSpeed;

  int get targetSpeed => _targetSpeed;

  String get id => _id;
  Map<String, dynamic> _speeds = {};
  late int _runStarted;
  late int _runEnded;

  Session();

  /// Returns the runtime of the session as a string
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'targetSpeed': _targetSpeed,
      'runStarted': _runStarted,
      'runEnded': _runEnded,
      'speeds': _speeds,
    };
  }

  /// Returns a session from a json map
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session()
      .._id = json['id']
      .._targetSpeed = json['targetSpeed']
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
  late Timer _saveSessionTimer;
  int _sessionCount = 0;
  int get sessionCount => _sessionCount;

  bool get isRunning => _isRunning;
  final double _msToKmhFactor = 3.6;

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  /// Loads all sessions from the local storage
  Future<void> loadSessionsFromJson() async {
    _sessions = await SessionFileManager().loadAllSessions();
    _sessionCount = _sessions.length;
    sortSessionsByDate();
  }

  void sortSessionsByDate() {
    _sessions.sort((a, b) => b._runStarted.compareTo(a._runStarted));
  }

  /// Tracks the time of the current session
  /// If the time is over 4 hours, the session is stopped and a new one is created
  void _trackSessionTime() {
    int time = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRunning) {
        timer.cancel();
        return;
      }
      time++;
      /// 14.400 seconds = 4 hours
      /// +1 second to for the 1 second delay of the timer
      if (time == 14401) {
        stopSessionTracking(true);
        _subscription.cancel();
        _saveSessionTimer.cancel();
        createNewSession();
        continueSessionTracking();
        timer.cancel();
      }
    });
  }

  /// Creates a new session and starts tracking
  void createNewSession() {
    if (_sessionCount > 49) {
      deleteSession(_sessions.last.id);
    }
    _currentSession = Session();
    var time = DateTime.now().millisecondsSinceEpoch;
    _currentSession._runStarted = time;
    _currentSession._runEnded = time;
    _currentSession._targetSpeed = Settings().targetSpeed;
    if (kDebugMode) {
      logger.dataLogger
          .v("Session started at ${DateTime.now().millisecondsSinceEpoch}");
    }
  }

  /// Starts tracking the current session
  void continueSessionTracking() {
    if (_isRunning) {
      return;
    }
    _isRunning = true;
    _trackSessionTime();
    _saveSessionPeriodically();
    _subscription = SensorData().normalizedSpeedStream.listen(
      (double speed) {
        var time = DateTime.now().millisecondsSinceEpoch;
        _currentSession._speeds[time.toString()] = speed * _msToKmhFactor;
        _currentSession._runEnded = time;
        if (kDebugMode) {
          logger.dataLogger
              .v("Runtime: ${getRunTimeAsString(_currentSession)}, "
                  "Top Speed: ${getTopSpeed(_currentSession)}, "
                  "Average Speed: ${getAverageSpeedAsString(_currentSession)}, "
                  "Timestamp: ${DateTime.now().millisecondsSinceEpoch}");
        }
      },
    );
  }

  /// Pauses tracking the current session
  void pauseSessionTracking() {
    if (!_isRunning) {
      return;
    }
    _isRunning = false;
    _subscription.cancel();
  }

  /// Stops tracking the current session
  void stopSessionTracking(bool keep) {
    if (!_isRunning) {
      return;
    }
    _isRunning = false;
    keepSessionAtEndOfRun(keep);
  }

  /// Saves the current session to the local storage
  void _saveSession() {
    SessionFileManager().saveSession(_currentSession);
  }

  /// Deletes the session with the given id from the local storage and the list
  void deleteSession(String id) {
    SessionFileManager().deleteSession(id);
    _sessions.removeWhere((session) => session.id == id);
  }

  /// Deletes all sessions from the local storage and the list
  void deleteAllSessions() {
    SessionFileManager().deleteAllSessions();
    sessions.clear();
  }

  /// Saves the current session to the local storage periodically
  void _saveSessionPeriodically() {
    if (!_isRunning) {
      return;
    }
    _saveSessionTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isRunning) {
        timer.cancel();
        return;
      }
      _saveSession();
    });
  }

  /// Saves the current session or deletes it
  void keepSessionAtEndOfRun(bool keep) {
    if (keep) {
      _saveSession();
      _sessionCount++;
      _sessions.add(_currentSession);
      sortSessionsByDate();
    } else {
      deleteSession(_currentSession.id);
    }
  }

  Map<String, dynamic> getSpeeds(Session session) {
    return session._speeds;
  }

  /// Returns the top speed of the session
  String getTopSpeed(Session session) {
    double currentMaximum = 0;
    if (session._speeds.isNotEmpty) {
      session._speeds.forEach((key, value) {
        if (value > currentMaximum) {
          currentMaximum = value;
        }
      });
    }
    return currentMaximum.toStringAsFixed(2);
  }

  /// Returns the average speed of the session
  String getAverageSpeedAsString(Session session) {
    double sum = 0;
    if (session._speeds.isNotEmpty) {
      session._speeds.forEach((key, value) {
        sum += value;
      });
      return (sum / session._speeds.length).toStringAsFixed(2);
    }
    return "";
  }

  Duration getCurrentTimeAtSession(int currentTime, Session session) {
    return DateTime.fromMillisecondsSinceEpoch(currentTime)
        .difference(DateTime.fromMillisecondsSinceEpoch(session._runStarted));
  }

  /// Returns the run time of the session as a string
  String getRunTimeAsString(Session session) {
    Duration currentTime = DateTime.fromMillisecondsSinceEpoch(session._runEnded)
        .difference(DateTime.fromMillisecondsSinceEpoch(session._runStarted));
    return DateFormat('HH:mm:ss').format(DateTime.utc(0).add(currentTime));
  }

  String getDateAsString(Session session) {
    return DateFormat('dd.MM.yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(session._runStarted));
  }

  /// Returns the start time of the session as a string
  String getStartTimeAsString(Session session) {
    return DateFormat('HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(session._runStarted));
  }

  /// Returns the end time of the session as a string
  String getEndTimeAsString(Session session) {
    return DateFormat('HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(session._runEnded));
  }

  String getTargetSpeed(Session session) {
    return session._targetSpeed.toString();
  }
}
