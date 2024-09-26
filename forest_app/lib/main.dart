import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forest_timer.dart';
import 'tree_growth_screen.dart';
import 'session_history_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForestTimer(),
      child: MaterialApp(
        title: 'Forest',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forest'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your focus time in minutes:',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter minutes',
              ),
            ),
            const SizedBox(height: 20),
            TimerDisplay(),
            const SizedBox(height: 20),
            FocusButton(controller: _controller),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const SessionHistoryScreen()),
                );
              },
              child: const Text('History of Sessions'),
            ),
          ],
        ),
      ),
    );
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
      style: TextStyle(
        fontSize: 24,
        color: timer.isGrowing ? Colors.green : Colors.red,
      ),
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
