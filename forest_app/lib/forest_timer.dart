import 'package:flutter/material.dart';
import 'dart:async';
import 'tree_growth_screen.dart';
import 'package:provider/provider.dart';

class ForestTimer with ChangeNotifier, WidgetsBindingObserver {
  int _timeLeft = 0;
  Timer? _timer;
  bool _isGrowing = false;
  bool _isDeadTree = false;

  int get timeLeft => _timeLeft;
  bool get isGrowing => _isGrowing;
  bool get isDeadTree => _isDeadTree;

  ForestTimer() {
    WidgetsBinding.instance.addObserver(this);
  }

  void startTimer(int duration, BuildContext context) {
    _isGrowing = true;
    _isDeadTree = false;
    _timeLeft = duration * 60;
    notifyListeners();

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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _isGrowing) {
      _isDeadTree = true;
      stopTimer();
      notifyListeners();
    }
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
            timer.startTimer(duration, context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a valid number of minutes.')),
            );
          }
        } else {
          timer.stopTimer();
          Navigator.of(context).pop();
        }
      },
      child: Text(timer.isGrowing ? 'Stop Focusing' : 'Start Focusing'),
    );
  }
}
