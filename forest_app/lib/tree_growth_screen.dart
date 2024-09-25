import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forest_timer.dart';

class TreeGrowthScreen extends StatelessWidget {
  const TreeGrowthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<ForestTimer>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Growing Tree'),
      ),
      body: Center(
        child: timer.isGrowing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(seconds: 1), 
                    width: 100,
                    height: 100 + (timer.timeLeft * 2 / 60),
                    child: Image.asset(timer.timeLeft > (timer.timeLeft ~/ 2)
                        ? 'assets/early_tree.png' 
                        : 'assets/growth_tree.png' 
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your tree is growing!',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Time Left: ${timer.timeLeft}s',
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              )
            : const Text(
                'Your tree has grown. Start focusing again to grow a new one!',
                style: TextStyle(fontSize: 24, color: Colors.red),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
