import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TipButton extends StatelessWidget{
  const TipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Tip us a coffee"),
      leading: const Icon(Icons.attach_money_outlined),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        launchUrlString("https://www.paypal.me/jberger18", mode: LaunchMode.externalApplication);
      },
    );
  }

}