import 'package:flutter/material.dart';

import 'package:jog_dog/Models/run.dart';
import 'package:jog_dog/pages/page_run_insights.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Run> runs = [
    Run(const Duration(minutes: 40), 10, 6, DateTime.now()),
    Run(const Duration(minutes: 47), 14, 4, DateTime.april),
    Run(const Duration(minutes: 75), 28, 7, DateTime.january),
    Run(const Duration(minutes: 26), 12, 2, DateTime.february),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: ListView.builder(
          itemCount: runs.length,
          itemBuilder: ((context, index) {
            final run = runs[index];
            return Card(
                child: ListTile(
                    title: Text('Run vom ${run.date.day.toString()}.${run.date.month.toString()}.${run.date.year.toString()}'),
                    trailing: const Icon(Icons.run_circle),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: ((context) => RunInsights(run: run))));
                    },));
          })),
    );
  }
}
