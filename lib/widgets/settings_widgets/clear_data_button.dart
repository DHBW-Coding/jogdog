import 'package:flutter/material.dart';

class ClearDataButton extends StatelessWidget{
  const ClearDataButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Clear all data"),
      leading: const Icon(Icons.delete_forever_outlined),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {},
    );
  }

}