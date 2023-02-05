import 'dart:async';

import 'package:flutter/foundation.dart';
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
    startSessionTracking();
  }

  void loadSession(String uuid) {
    for (Session element in _sessions) {
      if (element._id == uuid) {
        _currentSession = element;
      }
    }
  }

  void startSessionTracking() {
    if (_isRunning) { return; }
    _isRunning = true;
    _subscription = _sensorData.normelizedSpeedStream.listen((double speed) {
      if (_isRunning) {
        _currentSession._speeds[DateTime.now().millisecondsSinceEpoch] = speed;
        if(kDebugMode) logger.dataLogger.v("Raw GPS Speed: $speed, Timestamp: ${DateTime.now().millisecondsSinceEpoch}");
      } else {
        _subscription.cancel();
      }
    });
  }

  void stopSessionTracking() {
    if (!_isRunning) { return; }
    _isRunning = false;
    _currentSession._runEnded = DateTime.now().millisecondsSinceEpoch;
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

}
