import 'package:flutter/material.dart';

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  ThemeSelectorState createState() => ThemeSelectorState();
}

class ThemeSelectorState extends State<ThemeSelector> {
  final Map<String, IconData> themes = {
    "Automatic": Icons.brightness_auto,
    "Dark Theme": Icons.brightness_3,
    "Light Theme": Icons.brightness_medium
  };

  late String _selectedTheme = "Automatic";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Select theme'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showModalBottomSheet<void>(
          enableDrag: true,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setThemeState) => SizedBox(
                height: themes.length * 100,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: themes.length,
                    itemBuilder: (context, index) {
                      String theme = themes.keys.elementAt(index);
                      return RadioListTile(
                        value: theme.toString(),
                        groupValue: _selectedTheme,
                        controlAffinity: ListTileControlAffinity.trailing,
                        secondary: Icon(themes[theme]),
                        onChanged: (value) {
                          setThemeState(
                            () {
                              _selectedTheme = value.toString();
                            },
                          );
                        },
                        title: Text(
                          theme,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
