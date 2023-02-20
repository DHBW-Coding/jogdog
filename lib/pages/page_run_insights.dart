import 'package:flutter/material.dart';
import 'package:jog_dog/Models/run.dart';

class RunInsights extends StatelessWidget {
  final Run run;

  const RunInsights({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${run.date.day.toString()}.${run.date.month.toString()}.${run.date.year.toString()}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Run from ${run.date.day.toString()}.${run.date.month.toString()}.${run.date.year.toString()}'),
            Text('Your average run speed was: ${run.avgSpeed}.'),
            Text('The run lasted for: ${run.duration.toString()}'),
          ],
        ),
      ),
    );
  }
}
