import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_app/forest_timer.dart';

class MockForestTimer extends Mock implements ForestTimer {}

void main() {
  group('Mocked ForestTimer Tests', () {
    test('verifies that stopTimer is called when timer is stopped', () {
      final mockTimer = MockForestTimer();
      mockTimer.startTimer(1);
      mockTimer.stopTimer();
      verify(mockTimer.stopTimer()).called(1);
    });

    test('verifies that startTimer is called with correct duration', () {
      final mockTimer = MockForestTimer();
      mockTimer.startTimer(1);
      verify(mockTimer.startTimer(1)).called(1);
    });
  });
}
