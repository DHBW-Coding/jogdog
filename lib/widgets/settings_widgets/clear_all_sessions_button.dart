import 'package:flutter/material.dart';

class ClearAllSessionsButton extends StatelessWidget {
  const ClearAllSessionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Clear all sessions"),
      leading: const Icon(Icons.cleaning_services_rounded),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Deleting all sessions!"),
                content: const Text(
                    "Are you sure you want to delete all saved sessions?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, "Cancel"),
                    child: const Text("Cancel"),
                  ),
                  TextButton(onPressed: () {
                    // Todo: Delete sessions
                    Navigator.pop(context, "Ok");
                  }, child: const Text("Ok"))
                ],
              );
            });
      },
    );
  }
}
