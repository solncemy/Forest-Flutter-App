import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_app/forest_timer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ForestTimer', () {
    test('starts timer correctly', () {
      final timer = ForestTimer();
      timer.startTimer(1);
      expect(timer.isGrowing, true);
      expect(timer.isDeadTree, false);
    });

    test('stops timer correctly', () {
      final timer = ForestTimer();
      timer.startTimer(1);
      timer.stopTimer();
      expect(timer.isGrowing, false);
    });

    test('changes to dead tree state when paused', () {
      final timer = ForestTimer();
      timer.startTimer(1);
      timer.didChangeAppLifecycleState(AppLifecycleState.paused);
      expect(timer.isDeadTree, true);
      expect(timer.isGrowing, false);
    });
  });
}
