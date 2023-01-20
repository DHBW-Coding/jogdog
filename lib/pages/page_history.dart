import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("History"),
        ),
        body: ListView(children:
            // This ListView is later to be replaced by a ListView.builder for dynamic
            // generation of the Elements
            const [
          Center(
              child: SizedBox(
            height: 50,
            width: 350,
            child: Card(
              child: Center(
                child: Text("History 1"),
              ),
            ),
          )),
          Center(
              child: SizedBox(
            height: 50,
            width: 350,
            child: Card(
              child: Center(
                child: Text("History 2"),
              ),
            ),
          )),
          Center(
              child: SizedBox(
                  height: 50,
                  width: 350,
                  child: Card(
                    child: Center(
                      child: Text("History 3"),
                    ),
                  ))),
        ]));
  }
}
