import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ImprintButton extends StatelessWidget {
  const ImprintButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Imprint"),
      leading: const Icon(Icons.account_balance_outlined),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Imprint",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                body: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          child: ListTile(
                            title: const Text("Maxim Andreev"),
                            subtitle: const Text("Creator of animated dog gif and logos"),
                            leading: const Icon(Icons.account_balance_outlined),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              launchUrlString(
                                  "https://www.behance.net/maximandreev", mode: LaunchMode.externalApplication);
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ),
              );
            },
          ),
        );
      },
    );
  }
}
