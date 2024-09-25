import 'package:flutter/material.dart';
import 'dart:async';
import 'tree_growth_screen.dart';
import 'package:provider/provider.dart';

class ForestTimer with ChangeNotifier {
  int _timeLeft = 0;
  Timer? _timer;
  bool _isGrowing = false;

  int get timeLeft => _timeLeft;
  bool get isGrowing => _isGrowing;

  void startTimer(int duration, BuildContext context) {
    _isGrowing = true;
    _timeLeft = duration * 60; // Convert minutes to seconds
    notifyListeners();

    // Navigate to the Tree Growth Screen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const TreeGrowthScreen()),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        _isGrowing = false;
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _isGrowing = false;
    _timer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class TimerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timer = context.watch<ForestTimer>();
    return Text(
      timer.isGrowing
          ? 'Time Left: ${timer.timeLeft}s'
          : 'Focus Time is Over!',
      style: TextStyle(fontSize: 24, color: timer.isGrowing ? Colors.green : Colors.red),
    );
  }
}

class FocusButton extends StatelessWidget {
  final TextEditingController controller;

  const FocusButton({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<ForestTimer>();
    return ElevatedButton(
      onPressed: () {
        if (!timer.isGrowing) {
          final int? duration = int.tryParse(controller.text);
          if (duration != null && duration > 0) {
            timer.startTimer(duration, context); // Pass the duration in minutes
          } else {
            // Show an error message if the input is invalid
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a valid number of minutes.')),
            );
          }
        } else {
          timer.stopTimer();
          Navigator.of(context).pop(); // Go back when stopping
        }
      },
      child: Text(timer.isGrowing ? 'Stop Focusing' : 'Start Focusing'),
    );
  }
}
