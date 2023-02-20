import 'package:flutter/material.dart';

import '../../utilities/debugLogger.dart';

class DebuggerButton extends StatelessWidget{
  const DebuggerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Show debug console"),
      leading: const Icon(Icons.announcement_outlined),
      onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                const LogWidgetContainer()));
      },
    );
  }

}