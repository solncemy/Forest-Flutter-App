import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forest_timer.dart';

class SessionHistoryScreen extends StatelessWidget {
  const SessionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionHistory = context.watch<ForestTimer>().sessionHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session History'),
      ),
      body: sessionHistory.isEmpty
          ? const Center(
              child: Text(
                'No session history yet.',
                style: TextStyle(fontSize: 24),
              ),
            )
          : ListView.builder(
              itemCount: sessionHistory.length,
              itemBuilder: (context, index) {
                final session = sessionHistory[index];
                final bool isCompleted = session['completed'] ?? false;
                final duration = session['duration'] ?? 0;
                final date = DateTime.parse(session['date']);

                return ListTile(
                  leading: Image.asset(
                    isCompleted ? 'assets/growth_tree.png' : 'assets/dead_tree.png',
                    width: 60,
                    height: 60,
                  ),
                  title: Text(
                    'Duration: $duration mins',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Date: ${date.day}/${date.month}/${date.year}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
