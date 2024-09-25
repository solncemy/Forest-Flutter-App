import 'package:flutter/material.dart';

class SessionHistoryScreen extends StatelessWidget {
  const SessionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session History'),
      ),
      body: Center(
        child: const Text(
          'No session history yet.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
