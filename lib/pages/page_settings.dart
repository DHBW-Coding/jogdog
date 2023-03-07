import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/local_music_controller.dart';
import 'package:jog_dog/utilities/settings.dart';
import 'package:jog_dog/widgets/settings_widgets/about_us_button.dart';
import 'package:jog_dog/widgets/settings_widgets/clear_all_sessions_button.dart';
import 'package:jog_dog/widgets/settings_widgets/debugger_button.dart';
import 'package:jog_dog/widgets/settings_widgets/default_targetSpeed_selector.dart';
import 'package:jog_dog/widgets/settings_widgets/get_in_touch_button.dart';
import 'package:jog_dog/widgets/settings_widgets/imprint_button.dart';
import 'package:jog_dog/widgets/settings_widgets/playlist_selector.dart';
import 'package:jog_dog/widgets/settings_widgets/privacy_policy_button.dart';
import 'package:jog_dog/widgets/settings_widgets/report_a_bug_button.dart';
import 'package:jog_dog/widgets/settings_widgets/tip_button.dart';
import 'package:jog_dog/widgets/settings_widgets/tolerance_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<PlaylistSelectorState> _playlistSelectorKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: ListView(
            children: <Widget>[
              ///Start of General Settings -------------------------------------
              Text("General", style: Theme.of(context).textTheme.headlineSmall),
              Card(
                child: Column(
                  children: [
                    ///Opens a modalBottomSheet to select the standard default speed the user wants to hold
                    DefaultTargetSpeedSelector(),

                    ///Opens a modalBottomSheet to select the tolerance of a run
                    ToleranceSelector(),

                    ///Opens a DropdownButton to select a playlist
                    PlaylistSelector(key: _playlistSelectorKey,),

                    /// A button to delete all session that are stored
                    const ClearAllSessionsButton(),

                    /// A button to restore all default settings
                    resetSettingsButton(),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              ///Start of Support Settings -------------------------------------
              Text("Support", style: Theme.of(context).textTheme.headlineSmall),
              Card(
                child: Column(
                  children: const [
                    /// Opens a mail with pre written mail and subject
                    GetInTouchButton(),
                    ReportABugButton(),
                    PrivacyPolicyButton(),
                    AboutUsButton(),
                    ImprintButton(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Column(
                  children: const [
                    /// Opens a link to tip the developers
                    TipButton(),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              ///Start of development Settings ---------------------------------
              if (kDebugMode)
                Text("Development",
                    style: Theme.of(context).textTheme.headlineSmall),
              if (kDebugMode)
                Card(
                  child: Column(
                    children: const [
                      ///Open the debugging console
                      DebuggerButton(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resetSettingsButton() {
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
                    onPressed: () async {
                      setState(() {
                        Settings().resetSettings();
                        localMusicController().resetDirectoryPath();
                      });
                      _playlistSelectorKey.currentState?.updateSelector();
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
