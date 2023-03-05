import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/debug_logger.dart';
import 'package:jog_dog/utilities/settings.dart';

class DefaultTargetSpeedSelector extends StatelessWidget {
  DefaultTargetSpeedSelector({super.key});

  int selectedSpeed = Settings().targetSpeed;
  int _selectedItem = Settings().targetSpeed - 5;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Select default target speed"),
      leading: const Icon(Icons.speed_outlined),
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
                    childCount: 16,
                    builder: (context, index) {
                      return Text(
                        "${index + 5} km/h",
                        style: Theme.of(context).textTheme.titleLarge,
                      );
                    },
                  ),
                  onSelectedItemChanged: (value) {
                    selectedSpeed = value + 5;
                    _selectedItem = value;
                    if (kDebugMode) {
                      allLogger.i(
                          "Selected tolerance $selectedSpeed\n Selected item $_selectedItem");
                    }
                  },
                ),
              ),
            );
          },
        ).whenComplete(() => Settings().setTargetSpeed(selectedSpeed));
      },
    );
  }
}
