import 'package:flutter/material.dart';
import 'tree_growth_screen.dart';
import 'dart:async';

class ForestTimer with ChangeNotifier, WidgetsBindingObserver {
  int _timeLeft = 0;
  Timer? _timer;
  bool _isGrowing = false;
  bool _isDeadTree = false;
  List<Map<String, dynamic>> _sessionHistory = [];

  int get timeLeft => _timeLeft;
  bool get isGrowing => _isGrowing;
  bool get isDeadTree => _isDeadTree;
  List<Map<String, dynamic>> get sessionHistory => _sessionHistory;

  ForestTimer() {
    WidgetsBinding.instance.addObserver(this);
  }

  void startTimer(int duration, [BuildContext? context]) {
  _isGrowing = true;
  _isDeadTree = false;
  _timeLeft = duration * 60;
  notifyListeners();

  if (context != null) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const TreeGrowthScreen()),
    );
  }

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
    if (_isGrowing) {
      _isDeadTree = true;
      addSession(false);
    }
    _isGrowing = false;
    _timer?.cancel();
    notifyListeners();
  }

  void completeSession() {
    _isGrowing = false;
    _isDeadTree = false;
    addSession(true);
  }

  void addSession(bool completed) {
    final now = DateTime.now();
    _sessionHistory.add({
      'duration': (_timeLeft / 60).ceil(),
      'date': now.toIso8601String(),
      'completed': completed,
    });
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
