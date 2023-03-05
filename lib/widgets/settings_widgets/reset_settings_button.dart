import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/settings.dart';
import 'package:jog_dog/theme/theme.dart';

class ResetSettingsButton extends StatelessWidget {
  const ResetSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Reset settings"),
      leading: const Icon(Icons.settings_backup_restore),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Resetting all settings!"),
              content: const Text(
                  "Are you sure you want to reset all your settings?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, "Cancel"),
                  child: const Text("Cancel"),
                ),
                TextButton(
                    onPressed: () {
                      Settings().setTheme(Themes.automatic);
                      Settings().setTolerance(0.05);
                      Settings().setTargetSpeed(10);
                      Settings().setMusicPath("");
                      Navigator.pop(context, "Ok");
                    },
                    child: const Text("Ok"))
              ],
            );
          },
        );
      },
    );
  }
}
