import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';

import 'package:penuhan/screens/game_play.dart';
import 'package:penuhan/utils/assets.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with WidgetsBindingObserver {
  String _versionNumberText = "Loading...";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FlameAudio.bgm.play(Assets.bgmTitle, volume: 1);
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _versionNumberText = 'v${packageInfo.version}+${packageInfo.buildNumber}';
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    FlameAudio.bgm.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      FlameAudio.bgm.pause();
    } else if (state == AppLifecycleState.resumed) {
      FlameAudio.bgm.resume();
    }
  }

  // Method to show the language selection dialog
  void _showLanguageDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: Text(
            localizations.languageDialogTitle,
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'English',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // TODO: Implement logic to change app locale to 'en'
                  // This typically involves a state management solution (like Provider)
                  // to update the locale in your MaterialApp widget.
                  print("Language set to English");
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(
                  'Bahasa Indonesia',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // TODO: Implement logic to change app locale to 'id'
                  print("Language set to Indonesian");
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(Assets.gameLogo, height: 150.0),
              const SizedBox(height: 60.0),

              // Embark Button
              // TODO Save file for new game and continue
              // Up to 3 save file
              _buildMenuButton(context, localizations.mainMenuEmbark, () {
                FlameAudio.bgm.stop();
                FlameAudio.play(Assets.sfxClick);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const GamePlay()),
                );
              }),
              const SizedBox(height: 20.0),

              // Settings Button
              // TODO: Modal pop up
              // SFX Toggle
              // BGM Toggle
              _buildMenuButton(
                context,
                localizations.mainMenuSettings,
                // () {
                //   FlameAudio.play(Assets.sfxClick);
                //   _showSettingsDialog(context);
                // }
                // not yet implemented
                null,
              ),
              const SizedBox(height: 20.0),

              // About Button
              // TODO: Modal pop up
              // License : Music (chagasi)
              // Socials : Instagram, Itch io
              _buildMenuButton(
                context,
                localizations.mainMenuAbout,
                // () {
                //   FlameAudio.play(Assets.sfxClick);
                //   _showAboutDialog(context);
                // }
                // not yet implemented
                null,
              ),
              const SizedBox(height: 20.0),

              // Language Button
              // TODO: Modal pop up to change language
              _buildMenuButton(
                context,
                localizations.mainMenuLanguage,
                // () {
                //   FlameAudio.play(Assets.sfxClick);
                //   _showLanguageDialog(context);
                // }
                // not yet implemented
                null,
              ),
              const Spacer(),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _versionNumberText,
                    style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                  Text(
                    localizations.copyrightNotice,
                    style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String text,
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      width: 250,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(
            color: onPressed != null ? Colors.white : Colors.grey.shade800,
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: onPressed != null ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
