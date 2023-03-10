import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/debug_logger.dart';
import 'package:jog_dog/utilities/settings.dart';

class InertiaSelector extends StatelessWidget {
  InertiaSelector({super.key});

  int selectedInertia = Settings().inertia;
  int _selectedItem = Settings().inertia - 1;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Music adjustment time"),
      leading: const Icon(Icons.ac_unit_outlined),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showModalBottomSheet<void>(
          enableDrag: true,
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
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
                    childCount: 10,
                    builder: (context, index) {
                      return index == 0
                          ? Text(
                              "${index + 1} second",
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          : Text(
                              "${index + 1} seconds",
                              style: Theme.of(context).textTheme.titleLarge,
                            );
                    },
                  ),
                  onSelectedItemChanged: (value) {
                    selectedInertia = value + 1;
                    _selectedItem = value;
                    if (kDebugMode) {
                      allLogger.i(
                          "Selected tolerance $selectedInertia\n Selected item $_selectedItem");
                    }
                  },
                ),
              ),
            );
          },
        ).whenComplete(() => Settings().setInertia(selectedInertia));
      },
    );
  }
}
