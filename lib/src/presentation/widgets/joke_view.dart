import 'dart:math';

import 'package:flutter/material.dart';

// JokeView is a StatelessWidget that styles displays a joke beautifully.

class JokeView extends StatefulWidget {
  const JokeView({required this.joke, super.key});
  final String joke;

  @override
  // ignore: library_private_types_in_public_api
  _JokeViewState createState() => _JokeViewState();
}

class _JokeViewState extends State<JokeView> {
  bool _isJokeVisible = false;
  late List<Color> _gradientColors;

  @override
  void initState() {
    super.initState();
    // Generate random gradient colors
    _gradientColors = [
      // Colors.purple[300]!,
      // Colors.deepPurple[500]!,
      Color(0xFF000000 + Random().nextInt(0xFFFFFF)),
      Color(0xFF000000 + Random().nextInt(0xFFFFFF)),
    ];

    // Delay the animation to make it more playful
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isJokeVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AnimatedOpacity(
        duration: const Duration(seconds: 1), // Fading animation duration
        opacity: _isJokeVisible ? 1.0 : 0.0, // Start with 0 opacity
        child: AnimatedContainer(
          duration: const Duration(seconds: 1), // Gradient animation duration
          curve: Curves.easeOut,
          width: _isJokeVisible ? MediaQuery.sizeOf(context).width : 0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(_isJokeVisible ? 16 : 0),
            boxShadow: _isJokeVisible
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: _isJokeVisible
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '😄', // Laughing emoji
                          style: TextStyle(
                            fontSize: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.joke,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
