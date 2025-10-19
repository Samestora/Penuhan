import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:penuhan/utils/save_manager.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';
import 'package:penuhan/screens/splash_screen.dart';

const String settingsBoxName = 'settings';
const String languageKey = 'language';
const String bgmEnabledKey = 'bgm_enabled';
const String sfxEnabledKey = 'sfx_enabled';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setPortrait();

  await Hive.initFlutter();
  await SaveManager.instance.initialize();
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

        final baseTheme = ThemeData(
          fontFamily: 'Unifont',
          listTileTheme: const ListTileThemeData(
            titleTextStyle: TextStyle(
              fontFamily: 'Unifont',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          highlightColor: Colors.white.withAlpha(
            200,
          ), // Color on press-and-hold
          splashColor: Colors.white.withAlpha(
            150,
          ), // Color of the ripple itself
        );

        return MaterialApp(
          // Debug settings that are automatically disabled in release mode
          showPerformanceOverlay: kDebugMode,
          debugShowCheckedModeBanner: kDebugMode,

          theme: baseTheme.copyWith(brightness: Brightness.light),
          darkTheme: baseTheme.copyWith(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
          ),
          themeMode: ThemeMode.dark,

          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          locale: Locale(langCode),

          home: const SplashScreen(),
        );
      },
    );
  }
}
