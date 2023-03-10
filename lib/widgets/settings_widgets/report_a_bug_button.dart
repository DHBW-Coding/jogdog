import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReportABugButton extends StatelessWidget{
  const ReportABugButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Report a bug"),
      leading: const Icon(Icons.bug_report),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        launchUrlString("https://github.com/DHBW-Coding/jogdog/issues/new", mode: LaunchMode.externalApplication);
      },
    );
  }

}