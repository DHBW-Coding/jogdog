import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jog_dog/utilities/debugLogger.dart';

class ToleranceSelector extends StatefulWidget {
  const ToleranceSelector({super.key});

  @override
  ToleranceSelectorState createState() => ToleranceSelectorState();
}

class ToleranceSelectorState extends State<ToleranceSelector> {
  late int selectedTolerance = 5;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Select tolerance"),
      leading: const Icon(Icons.toll_outlined),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showModalBottomSheet<void>(
          enableDrag: true,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setToleranceState) => SizedBox(
                height: 300,
                child: Center(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 30,
                    controller: FixedExtentScrollController(
                        initialItem: selectedTolerance ~/ 5),
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    overAndUnderCenterOpacity: 0.5,
                    physics: const FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 21,
                      builder: (context, index) {
                        return Text(
                          "${index * 5}%",
                          style: Theme.of(context).textTheme.titleLarge,
                        );
                      },
                    ),
                    onSelectedItemChanged: (value) {
                      setToleranceState(() {
                        selectedTolerance =  value * 5;
                        if(kDebugMode) {
                          allLogger.i("Selected tolerance $selectedTolerance");
                        }
                      });
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
