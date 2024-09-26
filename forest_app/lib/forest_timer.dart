import 'package:flutter/material.dart';
import 'tree_growth_screen.dart';
import 'dart:async';
import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // Import for shared preferences

class ForestTimer with ChangeNotifier, WidgetsBindingObserver {
  int _timeLeft = 0;
  int _originalDuration = 0; // Store the original duration here
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
    loadSessionHistory(); // Load history on initialization
  }

  void startTimer(int duration, [BuildContext? context]) {
    _isGrowing = true;
    _isDeadTree = false;
    _originalDuration = duration; // Store the original duration
    _timeLeft = duration * 60; // Set time left to the duration in seconds
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
        completeSession(); // Call completeSession when time is up
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
    saveSessionHistory(); // Save history when stopping the timer
  }

  void completeSession() {
    _isGrowing = false;
    _isDeadTree = false;
    addSession(true);
  }

  void addSession(bool completed) {
    final now = DateTime.now();
    _sessionHistory.add({
      'duration': _originalDuration, // Use the original duration here
      'date': now.toIso8601String(),
      'completed': completed,
    });
    notifyListeners();
    saveSessionHistory(); // Save history after adding a session
  }

  Future<void> saveSessionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> sessionStrings = _sessionHistory
        .map((session) => json.encode(session))
        .toList();
    await prefs.setStringList('sessionHistory', sessionStrings);
  }

  Future<void> loadSessionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? sessionStrings = prefs.getStringList('sessionHistory');

    if (sessionStrings != null) {
      _sessionHistory = sessionStrings
          .map((sessionString) => Map<String, dynamic>.from(json.decode(sessionString)))
          .toList();
      notifyListeners(); // Notify listeners after loading
    }
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
