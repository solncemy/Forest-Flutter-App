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
        child: timer.isDeadTree
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/dead_tree.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your tree has died. Start focusing again to grow a new one!',
                    style: TextStyle(fontSize: 24, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : timer.isGrowing
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        width: 100,
                        height: 100 + (timer.timeLeft * 2 / 60),
                        child: Image.asset(
                          'assets/growth_tree.png',
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Your tree is growing!',
                        style: TextStyle(fontSize: 24),
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
