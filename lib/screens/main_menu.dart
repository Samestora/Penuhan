import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:penuhan/screens/game_play.dart';
import 'package:penuhan/utils/assets.dart';

// 1. Convert the widget to a StatefulWidget
class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

// 2. Create the State class
class _MainMenuState extends State<MainMenu> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Listen to lifecycle changes
    FlameAudio.bgm.play(Assets.bgmTitle, volume: 1); // Use your asset constant
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Stop listening
    FlameAudio.bgm.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // The app is in the background
      FlameAudio.bgm.pause();
    } else if (state == AppLifecycleState.resumed) {
      // The app is in the foreground
      FlameAudio.bgm.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Game Title
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
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80.0), // Spacer
            // Play Button
            _buildMenuButton(context, 'Play', () {
              // When navigating to gameplay, you might want to stop
              // the main menu music and play a different track.
              FlameAudio.bgm.stop();
              FlameAudio.play(Assets.sfxClick);

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const GamePlay()),
              );
            }),
            const SizedBox(height: 20.0), // Spacer
            // Settings Button
            _buildMenuButton(context, 'Settings', () {
              // Navigate to settings_screen
            }),
          ],
        ),
      ),
    );
  }

  // This helper method is now part of the _MainMenuState class
  Widget _buildMenuButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 250, // Set a fixed width for the buttons
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.blue.shade300, width: 2),
          ),
          elevation: 5,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
