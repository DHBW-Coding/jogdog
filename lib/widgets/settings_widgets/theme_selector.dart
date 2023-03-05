import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/settings.dart';
import 'package:jog_dog/theme/theme.dart';

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  ThemeSelectorState createState() => ThemeSelectorState();
}

class ThemeSelectorState extends State<ThemeSelector> {
  final Map<Themes, IconData> themes = {
    Themes.automatic: Icons.brightness_auto,
    Themes.dark: Icons.brightness_3,
    Themes.light: Icons.brightness_medium,
  };

  late Themes _selectedTheme = Settings().theme;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Select theme'),
      trailing: const Icon(Icons.arrow_forward_ios),
      leading: const Icon(Icons.format_paint_outlined),
      onTap: () {
        showModalBottomSheet<void>(
          enableDrag: true,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setThemeState) => SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    elevation: 2,
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        height: 5,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: themes.length,
                      itemBuilder: (context, index) {
                        Themes theme = themes.keys.elementAt(index);
                        return RadioListTile(
                          value: theme,
                          groupValue: _selectedTheme,
                          controlAffinity: ListTileControlAffinity.trailing,
                          secondary: Icon(themes[theme]),
                          title: Text(
                            "${theme.name[0].toUpperCase()}${theme.name.substring(1).toLowerCase()}",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          onChanged: (value) {
                            setThemeState(
                              () {
                                _selectedTheme = value!;
                                Settings().setTheme(_selectedTheme);
                              },
                            );
                          },
                        );
                      },
                    ),
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
