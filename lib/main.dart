import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:penuhan/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortrait();

  runApp(
    MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: SplashScreen(),
    ),
  );
}