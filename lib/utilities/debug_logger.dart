import 'package:flutter/material.dart';
import 'package:logger_flutter_plus/logger_flutter_plus.dart';
import 'package:logger/logger.dart';

Logger allLogger = Logger(output: _appOutput);
Logger dataLogger = Logger(
    output: _appOutput,
    printer: PrettyPrinter(methodCount: 0, printTime: true));

LogConsoleManager _logConsoleManager = LogConsoleManager(isDark: true);
final _appOutput = _LogOutputHandler();

class LogWidgetContainer extends StatelessWidget {
  const LogWidgetContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: LogConsoleWidget(
          logConsoleManager: _logConsoleManager,
          showCloseButton: true,
        ),
      ),
    );
  }
}

class _LogOutputHandler extends LogOutput {
  _LogOutputHandler();

  @override
  void output(OutputEvent event) {
    _logConsoleManager.addLog(event);
  }
}
