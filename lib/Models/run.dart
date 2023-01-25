import 'package:flutter/material.dart';

class Run{

  Duration duration = Duration(seconds: 0);
  double avgSpeed = 0;
  double maxDeviation = 0;
  DateTime date = DateTime(2017);


  Run(duration, avgSpeed, maxDeviation, date){
    duration = duration;
    avgSpeed = avgSpeed;
    maxDeviation = maxDeviation;
    date = date;
  }

}