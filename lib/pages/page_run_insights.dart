import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jog_dog/utilities/session_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RunInsights extends StatelessWidget {
  final Session session;

  const RunInsights({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        SessionManager().getDateAsString(session),
        style: Theme.of(context).textTheme.headlineMedium,
      )),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Shows the date of the session
                    Text(
                      "Date",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(SessionManager().getDateAsString(session)),
                    ),
                    const Divider(height: 20),

                    /// Shows the time the session started and ended
                    Text(
                      "Run from",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ListTile(
                      leading: const Icon(Icons.directions_run_outlined),
                      title: Text(
                          '${SessionManager().getStartTimeAsString(session)} - ${SessionManager().getEndTimeAsString(session)}'),
                    ),
                    const Divider(height: 20),

                    /// Shows the total time of the session
                    Text(
                      "Total time",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ListTile(
                      leading: const Icon(Icons.timer),
                      title: Text(SessionManager().getRunTimeAsString(session)),
                    ),
                    const Divider(height: 20),

                    /// Shows the targetSpeed of the session
                    Text(
                      "Target speed",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ListTile(
                      leading: const Icon(Icons.speed_outlined),
                      title: Text(
                          "${SessionManager().getTargetSpeed(session)} km/h"),
                    ),
                    const Divider(height: 20),

                    /// Shows the average speed of the session
                    Text(
                      "Average speed",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ListTile(
                      leading: const Icon(Icons.speed),
                      title: Text(
                          '${SessionManager().getAverageSpeedAsString(session)} km/h'),
                    ),
                    const Divider(height: 20),

                    ///Shows the top speed of the session
                    Text(
                      "Top speed",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ListTile(
                      leading: const Icon(Icons.speed),
                      title:
                          Text('${SessionManager().getTopSpeed(session)} km/h'),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 50),
            Card(
              child: SfCartesianChart(
                title: ChartTitle(text: 'Speed over time'),
                primaryXAxis: DateTimeAxis(
                  title: AxisTitle(text: 'Hours into session'),
                  dateFormat: DateFormat.Hm(),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Speed in km/h'),
                  decimalPlaces: 2,
                ),
                series: <LineSeries>[
                  LineSeries<MapEntry<String, dynamic>, DateTime>(
                    dataSource:
                        SessionManager().getSpeeds(session).entries.toList(),
                    xValueMapper: (entry, _) => SessionManager()
                        .getCurrentTimeAtSession(session, int.parse(entry.key)),
                    yValueMapper: (entry, _) => entry.value,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
