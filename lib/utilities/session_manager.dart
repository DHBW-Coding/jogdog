import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:jog_dog/utilities/FileManager.dart';
import 'package:jog_dog/utilities/run_music_logic.dart';
import 'package:jog_dog/utilities/debugLogger.dart' as logger;
import 'package:uuid/uuid.dart';

class Session {

  String _id = const Uuid().v4();
  Map<int, double> _speeds = {};
  late int _runStarted;
  late int _runEnded;

  Session();

  Map<String, dynamic> toJson() {
    return {
      _id : {
        'runStarted': _runStarted,
        'runEnded': _runEnded,
        'speeds': _speeds,
      }
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session()
      .._id = json['id']
      .._speeds = json['speeds']
      .._runStarted = json['runStarted']
      .._runEnded = json['runEnded'];
  }

  double getRunTime() {
    return (_runEnded - _runStarted)/1000;
  }

  double getTopSpeed() {
    double currentMaximum = 0;
    if (_speeds.isNotEmpty) {
      _speeds.forEach((key, value) {
        if (value > currentMaximum) {
          currentMaximum = value;
        }
      });
    }
    return currentMaximum;
  }

  double getAverageSpeed() {
    double sum = 0;
    if (_speeds.isNotEmpty) {
      _speeds.forEach((key, value) { sum += value; });
      return sum / _speeds.length;
    }
    return 0;
  }

}

class SessionManager {

  final List<Session> _sessions = [];
  final SensorData _sensorData;
  late Session _currentSession;
  late StreamSubscription _subscription;
  bool _isRunning = false;

  SessionManager(this._sensorData);

  void addSession(Session session) {
    _sessions.add(session);
  }

  void createNewSession() {
    _currentSession = Session();
    _currentSession._runStarted = DateTime.now().millisecondsSinceEpoch;
    if(kDebugMode) logger.dataLogger.v("Session started at ${DateTime.now().microsecondsSinceEpoch}");
    continueSessionTracking();
    saveSessionPeriodically();
  }

  void loadSession(String uuid) {
    for (Session element in _sessions) {
      if (element._id == uuid) {
        _currentSession = element;
      }
    }
  }

  loadSessionsFromJson() {
    //_sessions = FileManager().getSessions() as List<Session>;
  }

  void continueSessionTracking() {
    if (_isRunning) { return; }
    _isRunning = true;
    _subscription = _sensorData.normelizedSpeedStream.listen((double speed) {
      var time = DateTime.now().millisecondsSinceEpoch;
      _currentSession._speeds[time] = speed;
      _currentSession._runEnded = time;
      if(kDebugMode) logger.dataLogger.v("Raw GPS Speed: $speed, Timestamp: ${DateTime.now().millisecondsSinceEpoch}");
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
    saveSession();
  }

  void saveSession() {
    //FileManager().saveSession(_currentSession);
  }

  void saveSessionPeriodically() {
    if (!_isRunning) { return; }
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if(!_isRunning) { timer.cancel(); }
      saveSession();
    });
  }

}
