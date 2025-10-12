import 'package:flutter/material.dart';
import 'package:penuhan/screens/main_menu.dart';
import 'package:flame_audio/flame_audio.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Anims
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToMainMenu() {
    FlameAudio.play("sfx/sfx_click_heavy.mp3");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainMenu()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector wraps the entire screen to detect taps anywhere.
    return GestureDetector(
      onTap: _navigateToMainMenu,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your game title.
              Text(
                'Penuhan',
                style: TextStyle(
                  fontSize: 56.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.blue.shade700,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              // Animated text to prompt the user.
              FadeTransition(
                opacity: _animation,
                child: const Text(
                  'Press anywhere to continue',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
