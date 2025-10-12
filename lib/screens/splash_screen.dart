import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:penuhan/screens/title_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // 1. Declare the controller
  late FlameSplashController controller;

  @override
  void initState() {
    super.initState();
    // 2. Initialize the controller with your custom durations
    controller = FlameSplashController(
      fadeInDuration: const Duration(milliseconds: 2000), // How long it takes to fade in
      waitDuration: const Duration(seconds: 3),           // How long it stays on screen
      fadeOutDuration: const Duration(milliseconds: 1000), // How long it takes to fade out
    );
  }

  @override
  void dispose() {
    // 4. Dispose the controller to prevent memory leaks
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlameSplashScreen(
      controller: controller,
      theme: FlameSplashTheme.dark,
      onFinish: (BuildContext context) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TitleScreen()),
        );
      },
      showAfter: (BuildContext context) {
        return Image.asset('assets/image/engine/sgdc_logo.png');
      },
    );
  }
}