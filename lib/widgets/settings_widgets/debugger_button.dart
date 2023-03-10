import 'package:flutter/material.dart';

import '../../utilities/debug_logger.dart';

class DebuggerButton extends StatelessWidget {
  const DebuggerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Show debug console"),
      leading: const Icon(Icons.announcement_outlined),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LogWidgetContainer(),
          ),
        );
      },
    );
  }
}
