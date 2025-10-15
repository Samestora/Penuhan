import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:penuhan/screens/splash_screen.dart';
import 'package:flame_audio/flame_audio.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// Future<void> main() async {
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortrait();

  // await initHive();

  // Conflicting with Image.asset() with Flame.images.load()
  // also making audio and images consistent with flutter ways of things
  Flame.images.prefix = '';
  FlameAudio.audioCache.prefix = '';

  runApp(
    MaterialApp(
      showPerformanceOverlay: true,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: SplashScreen(),
    ),
  );
}
