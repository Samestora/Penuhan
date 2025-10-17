import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import 'package:penuhan/l10n/generated/app_localizations.dart';
import 'package:penuhan/screens/splash_screen.dart';

// import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortrait();

  // Placeholder for initializing the Hive database for save games
  // await initHive();

  // Clear the default Flame asset prefixes to use full paths
  // This makes asset handling consistent between Flutter and Flame
  Flame.images.prefix = '';
  FlameAudio.audioCache.prefix = '';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Debug settings that are automatically disabled in release mode
      showPerformanceOverlay: kDebugMode,
      debugShowCheckedModeBanner: kDebugMode,

      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      home: const SplashScreen(),
    );
  }
}
