import 'package:flutter/material.dart';

import 'package:jog_dog/Models/run.dart';
import 'package:jog_dog/pages/page_run_insights.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // TODO: fill with data from last runs :)
  List<Run> runs = [
    Run(const Duration(minutes: 40), 10, 6, DateTime.now(), DateTime.now()),
    Run(const Duration(minutes: 47), 14, 4, DateTime.now(), DateTime.now()),
    Run(const Duration(minutes: 75), 28, 7, DateTime.now(), DateTime.now()),
    Run(const Duration(minutes: 26), 12, 2, DateTime.now(), DateTime.now()),
    Run(const Duration(minutes: 26), 12, 2, DateTime.now(), DateTime.now()),
    Run(const Duration(minutes: 26), 12, 2, DateTime.now(), DateTime.now()),
    Run(const Duration(minutes: 26), 12, 2, DateTime.now(), DateTime.now()),
    Run(const Duration(minutes: 26), 12, 2, DateTime.now(), DateTime.now()),
    Run(const Duration(minutes: 26), 12, 2, DateTime.now(), DateTime.now()),
    Run(const Duration(minutes: 26), 12, 2, DateTime.now(), DateTime.now()),
    Run(const Duration(minutes: 26), 12, 2, DateTime.now(), DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 5),
        itemCount: runs.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: ((context, index) {
          final run = runs[index];
          return SizedBox(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ListTile(
                  title: Text(
                      '${run.date.day.toString()}.${run.date.month.toString()}.${run.date.year.toString()}'),
                  trailing: const Icon(Icons.run_circle),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => RunInsights(run: run))));
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
