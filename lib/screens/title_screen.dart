import 'package:flutter/material.dart';
import 'package:penuhan/screens/main_menu.dart';
import 'package:penuhan/utils/asset_manager.dart';
import 'package:penuhan/utils/audio_manager.dart';
import 'package:provider/provider.dart'; // Make sure this path is correct for your AssetManager

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
    final audioManager = context.read<AudioManager>();
    audioManager.playSfx(AssetManager.sfxClick);
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
              Image.asset(AssetManager.gameLogo, height: 150.0),
              const SizedBox(height: 100),
              FadeTransition(
                opacity: _animation,
                child: const Text(
                  'Press anywhere to continue',
                  style: TextStyle(color: Colors.white70, fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
