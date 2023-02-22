import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/debugLogger.dart';

class PlaylistSelector extends StatefulWidget {
  const PlaylistSelector({super.key});

  @override
  PlaylistSelectorState createState() => PlaylistSelectorState();
}

class PlaylistSelectorState extends State<PlaylistSelector> {
  // Todo: Get Playlists from the database and add them to this list
  List<String> playlists = <String>[
    "Rock",
    "Pop",
    "Hip Hop",
    "Rap",
    "Country",
    "Jazz",
    "Classical",
    "Metal",
    "EDM",
    "Reggae",
    "Folk",
  ];
  late String selectedPlaylist = playlists[_selectedItem];
  late int _selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Select Playlist"),
      leading: const Icon(Icons.my_library_music_outlined),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showModalBottomSheet<void>(
          enableDrag: true,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setPlaylistState) => SizedBox(
                height: 300,
                child: Center(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 30,
                    controller: FixedExtentScrollController(
                      initialItem: _selectedItem,
                    ),
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    overAndUnderCenterOpacity: 0.5,
                    physics: const FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: playlists.length,
                      builder: (context, index) {
                        return Text(
                          playlists[index],
                          style: Theme.of(context).textTheme.titleLarge,
                        );
                      },
                    ),
                    onSelectedItemChanged: (value) {
                      setPlaylistState(
                        () {
                          _selectedItem = value;
                          selectedPlaylist = playlists[value];
                          if (kDebugMode) {
                            allLogger.i(
                                "Selected tolerance $selectedPlaylist\n Selected item $_selectedItem");
                          }
                        },
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
