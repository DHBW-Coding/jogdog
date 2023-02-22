import 'package:flutter/material.dart';

class AboutUsButton extends StatelessWidget {
  const AboutUsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("About Us"),
      leading: const Icon(Icons.person_outline),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    "About Us",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                body: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Card(
                        child: Text("Hier könnte ihre about us page stehen"),
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
