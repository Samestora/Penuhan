import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:penuhan/l10n/generated/app_localizations.dart';
import 'package:penuhan/screens/splash_screen.dart';

const String settingsBoxName = 'settings';
const String languageKey = 'language';
const String bgmEnabledKey = 'bgm_enabled';
const String sfxEnabledKey = 'sfx_enabled';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortrait();

  await Hive.initFlutter();
  await Hive.openBox(settingsBoxName);

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
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(
        settingsBoxName,
      ).listenable(keys: [languageKey]),
      builder: (context, box, widget) {
        // Read the language code, defaulting to 'en' if not found.
        final langCode = box.get(languageKey, defaultValue: 'en');
        return MaterialApp(
          // Debug settings that are automatically disabled in release mode
          showPerformanceOverlay: kDebugMode,
          debugShowCheckedModeBanner: kDebugMode,

          themeMode: ThemeMode.dark,
          darkTheme: ThemeData.dark(),

          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          locale: Locale(langCode),

          home: const SplashScreen(),
        );
      },
    );
  }
}
