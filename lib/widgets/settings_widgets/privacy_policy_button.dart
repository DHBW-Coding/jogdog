import 'package:flutter/material.dart';

class PrivacyPolicyButton extends StatelessWidget {
  const PrivacyPolicyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Privacy Policy"),
      leading: const Icon(Icons.shield_outlined),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Privacy Policy",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                body: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Card(
                        child: Text("Hier könnte ihre privacy policy page stehen"),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
