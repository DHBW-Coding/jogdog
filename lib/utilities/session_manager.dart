import 'dart:async';

import 'package:flutter/foundation.dart';
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

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'runStarted': _runStarted,
      'runEnded': _runEnded,
      'speeds': _speeds.toString(),
    };
  }

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
  late Session _currentSession;
  late StreamSubscription _subscription;
  bool _isRunning = false;

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  void addSession(Session session) {
    _sessions.add(session);
  }

  void createNewSession() {
    _currentSession = Session();
    var time = DateTime.now().millisecondsSinceEpoch;
    _currentSession._runStarted = time;
    _currentSession._runEnded = time;
    if(kDebugMode) logger.dataLogger.v("Session started at ${DateTime.now().microsecondsSinceEpoch}");
    continueSessionTracking();
  }

  void loadSessionsFromJson() {
    _sessions = SessionFileManager().loadAllSessions() as List<Session>;
  }

  void continueSessionTracking() {
    if (_isRunning) { return; }
    _isRunning = true;
    _saveSessionPeriodically();
    _subscription = SensorData().normelizedSpeedStream.listen((double speed) {
      var time = DateTime.now().millisecondsSinceEpoch;
      _currentSession._speeds[time] = speed;
      _currentSession._runEnded = time;
      if(kDebugMode) logger.dataLogger.v("Runtime: ${getRunTimeAsString()}, Top Speed: ${getTopSpeed()}, Average Speed: ${getAverageSpeed()}, Timestamp: ${DateTime.now().millisecondsSinceEpoch}");
    });
  }

  void pauseSessionTracking() {
    if (!_isRunning) { return; }
    _isRunning = false;
    _subscription.cancel();
  }

  void stopSessionTracking() {
    if (!_isRunning) { return; }
    _isRunning = false;
    _subscription.cancel();
    _saveSession();
  }

  void _saveSession() {
    SessionFileManager().saveSession(_currentSession);
  }

  void _saveSessionPeriodically() {
    if (!_isRunning) { return; }
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if(!_isRunning) { timer.cancel(); }
      _saveSession();
      });
  }

  double getRunTime() {
    return (_currentSession._runEnded - _currentSession._runStarted)/1000;
  }

  double getTopSpeed() {
    double currentMaximum = 0;
    if (_currentSession._speeds.isNotEmpty) {
      _currentSession._speeds.forEach((key, value) {
        if (value > currentMaximum) {
          currentMaximum = value;
        }
      });
    }
    return currentMaximum;
  }

  double getAverageSpeed() {
    double sum = 0;
    if (_currentSession._speeds.isNotEmpty) {
      _currentSession._speeds.forEach((key, value) { sum += value; });
      return sum / _currentSession._speeds.length;
    }
    return 0;
  }

  String getRunTimeAsString() {
    double runTime = (_currentSession._runEnded - _currentSession._runStarted)/1000;
    double hours = runTime / 3600;
    double minutes = (runTime - hours * 3600) / 60;
    double seconds = runTime - hours * 3600 - minutes * 60;
    return "${hours.toString()}:${minutes.toString()}:${seconds.toString()}";
  }

}
