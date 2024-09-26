import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:forest_app/forest_timer.dart';
import 'package:forest_app/main.dart';

void main() {
  testWidgets('TimerDisplay Golden Test', (WidgetTester tester) async {
    final timer = ForestTimer();
    timer.startTimer(1, null);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => timer,
        child: MaterialApp(
          home: Scaffold(
            body: TimerDisplay(),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(TimerDisplay),
      matchesGoldenFile('goldens/timer_display_golden.png'),
    );
  });
}
