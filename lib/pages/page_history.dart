import 'package:flutter/material.dart';
import 'package:jog_dog/pages/page_run_insights.dart';
import 'package:jog_dog/utilities/session_manager.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SessionManager().sessions.isEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    title: Text("No sessions found"),
                    subtitle: Text(
                      "Start a session to see it here",
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/take_me_out_dog.png",
                      scale: 1.5,
                    ),
                  )
                ],
              )
            : ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 5),
                itemCount: SessionManager().sessions.length,
                itemBuilder: ((context, index) {
                  final session = SessionManager().sessions[index];
                  return SizedBox(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ListTile(
                          title:
                              Text(SessionManager().getDateAsString(session)),
                          subtitle: Text(
                              "${SessionManager().getStartTimeAsString(session)} - ${SessionManager().getEndTimeAsString(session)}"),
                          trailing: const Icon(Icons.run_circle),
                          leading: const Icon(Icons.notes_outlined),
                          onLongPress: () {
                            deleteSessionDialog(context, session);
                          },
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) =>
                                    RunInsights(session: session)),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),
      ),
    );
  }

  deleteSessionDialog(BuildContext context, Session session) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You are about to delete this session!'),
          content: const Text(
              'Are you sure you want to delete this session? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context, "Cancel"),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(
                  () {
                    SessionManager().deleteSession(session.id);
                  },
                );
                Navigator.pop(context, "Delete");
              },
            ),
          ],
        );
      },
    );
  }
}
