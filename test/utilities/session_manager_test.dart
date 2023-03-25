import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:jog_dog/utilities/session_manager.dart';

void main() {
  group("Testing different methods of the session_manager", () {

    final Session dummySession = Session.fromJson(jsonDecode(""
    "{\"id\": \"dummy-session\", "
    "\"targetSpeed\": 10, "
    "\"runStarted\": 0, "
    "\"runEnded\": 5775000, \"speeds\": {"
        "\"1000\": 1.00, "
        "\"2000\": 2.00, "
        "\"3000\": 3.00, "
        "\"4000\": 4.00, "
        "\"5000\": 5.00, "
        "\"6000\": 6.00, "
        "\"7000\": 7.00, "
        "\"8000\": 8.00, "
        "\"9000\": 9.00}}"));

    test("Test if the average Speed of the Session is calculated Correctly", () {
      String averageSpeed = SessionManager().getAverageSpeedAsString(dummySession);
      expect(averageSpeed, "5.00");
    });

    test("Test if the Top Speed of the Session is correct", () {
      String topSpeed = SessionManager().getTopSpeed(dummySession);
      expect(topSpeed, "9.00");
    });

    test("Correct Output of the Runtime", () {
      String timeInSession = SessionManager().getRunTimeAsString(dummySession);
      expect(timeInSession, "01:36:15");
    });

  });
}