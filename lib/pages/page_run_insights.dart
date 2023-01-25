import 'package:flutter/material.dart';
import 'package:jog_dog/Models/run.dart';


//TODO: handle Data from run better

class RunInsights extends StatelessWidget {
  RunInsights({super.key, required Run run}) {
    this._run = run;
  }

  Run _run = Run(Duration(seconds: 14), 3, 5, DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Run from ${_run.date.day.toString()}.${_run.date.month.toString()}.${_run.date.year.toString()}'),
                Text('Your average run speed was: ${_run.avgSpeed}.'),
                Text('The run lasted for: ${_run.duration.toString()}')
              ],
            )));
  }
}
