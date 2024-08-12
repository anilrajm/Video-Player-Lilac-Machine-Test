import 'dart:async';

import 'package:flutter/material.dart';


class OtpTimer extends ChangeNotifier {
  Timer? _timer;
  int _durationInSeconds = 60;

  bool get isRunning => _timer?.isActive ?? false;

  int get durationInSeconds => _durationInSeconds;

  void start() {
    _timer?.cancel();
    _durationInSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_durationInSeconds > 0) {
        _durationInSeconds--;
        notifyListeners();
      } else {
        stop();
      }
    });
  }

  void stop() {
    _timer?.cancel(); // Cancel the timer
    _timer = null;
    notifyListeners();
  }

  void restart() {
    _durationInSeconds = 60;
    start();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the object is disposed
    super.dispose();
  }

  String formatDuration() {
    final minutes = (_durationInSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_durationInSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
