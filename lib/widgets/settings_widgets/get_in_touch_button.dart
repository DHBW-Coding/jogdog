import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GetInTouchButton extends StatelessWidget{
  const GetInTouchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Get in touch"),
      leading: const Icon(Icons.mail_outline),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        launchUrlString(
            "mailto:ExampleMail@gmail.com?subject=Support%20Jog%20Dog&body=Hi%20there!");
      },
    );
  }

}