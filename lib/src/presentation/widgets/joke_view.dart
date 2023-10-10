import 'dart:math';

import 'package:flutter/material.dart';

// JokeView is a StatelessWidget that styles displays a joke beautifully.
class JokeView extends StatelessWidget {
  const JokeView({required this.joke, super.key});
  final String joke;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
            .withAlpha(80),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              joke,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
