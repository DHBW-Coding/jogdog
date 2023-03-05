import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jog_dog/widgets/settings_widgets/playlist_selector.dart';
import 'package:jog_dog/widgets/settings_widgets/theme_selector.dart';
import 'package:jog_dog/widgets/settings_widgets/tolerance_selector.dart';

import '../widgets/settings_widgets/about_us_button.dart';
import '../widgets/settings_widgets/clear_all_sessions_button.dart';
import '../widgets/settings_widgets/debugger_button.dart';
import '../widgets/settings_widgets/get_in_touch_button.dart';
import '../widgets/settings_widgets/privacy_policy_button.dart';
import '../widgets/settings_widgets/reset_settings_button.dart';
import '../widgets/settings_widgets/tip_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
              ///Start of Display Settings -------------------------------------
              Text("Display", style: Theme.of(context).textTheme.headlineSmall),
              Card(
                child: Column(
                  children: const [
                    /// Opens a bottomModalSheet to select the theme of the app
                    ThemeSelector(),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              ///Start of General Settings -------------------------------------
              Text("General", style: Theme.of(context).textTheme.headlineSmall),
              Card(
                child: Column(
                  children: const [
                    ///Opens a modalBottomSheet to select the tolerance of a run
                    ToleranceSelector(),

                    ///Opens a DropdownButton to select a playlist
                    PlaylistSelector(),

                    /// A button to delete all session that are stored
                    ClearAllSessionsButton(),

                    /// A button to restore all default settings
                    ResetSettingsButton(),
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
                    PrivacyPolicyButton(),
                    AboutUsButton(),
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
}
