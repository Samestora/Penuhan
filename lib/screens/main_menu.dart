import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:penuhan/l10n/generated/app_localizations.dart';
import 'package:penuhan/screens/game_play.dart';
import 'package:penuhan/utils/asset_manager.dart';
import 'package:penuhan/main.dart';
import 'package:penuhan/widgets/monochrome_button.dart';
import 'package:penuhan/widgets/monochrome_dropdown.dart';
import 'package:penuhan/widgets/monochrome_modal.dart';
import 'package:penuhan/utils/audio_manager.dart';

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
    AudioManager.instance.playBgmMenu();
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
    AudioManager.instance.stopBgm();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      AudioManager.instance.onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      AudioManager.instance.onAppResumed();
    }
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
              Image.asset(AssetManager.gameLogo, height: 150.0),
              const SizedBox(height: 60.0),

              // Embark Button
              MonochromeButton(
                text: localizations.mainMenuEmbark,
                onPressed: () {
                  AudioManager.instance.playSfx(AssetManager.sfxClick);
                  AudioManager.instance.stopBgm();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const GamePlay()),
                  );
                },
              ),
              const SizedBox(height: 20.0),

              // Settings Button - Now enabled!
              MonochromeButton(
                text: localizations.mainMenuSettings,
                onPressed: () {
                  AudioManager.instance.playSfx(AssetManager.sfxClick);
                  _showSettingsDialog();
                },
              ),
              const SizedBox(height: 20.0),

              // About Button
              MonochromeButton(
                text: localizations.mainMenuAbout,
                onPressed: () {
                  AudioManager.instance.playSfx(AssetManager.sfxClick);
                  _showAboutDialog();
                },
              ),
              const Spacer(),

              // Copyright and Version Text
              Column(
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

  // Helper functions
  /// Shows the settings dialog using the [_SettingsContent] class
  void _showSettingsDialog() {
    // use built in but with custom looks
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // The builder returns your custom widget, which will be shown as a dialog.
        return MonochromeModal(
          title: AppLocalizations.of(context)!.mainMenuSettings,
          child: const _SettingsContent(),
        );
      },
    );
  }

  /// Shows the about dialog using the [_AboutContent] class
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MonochromeModal(
          title: AppLocalizations.of(context)!.mainMenuAbout,
          child: const _AboutContent(),
        );
      },
    );
  }
}

class _SettingsContent extends StatefulWidget {
  const _SettingsContent();

  @override
  State<_SettingsContent> createState() => __SettingsContentState();
}

class __SettingsContentState extends State<_SettingsContent> {
  // The language selection dialog is no longer needed and can be removed.

  @override
  Widget build(BuildContext context) {
    // A map to define the available languages and their display names.
    final Map<String, String> languages = {
      'en': 'English',
      'id': 'Bahasa Indonesia',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // This builder handles the audio toggles.
        ValueListenableBuilder(
          valueListenable: Hive.box(
            settingsBoxName,
          ).listenable(keys: [bgmEnabledKey, sfxEnabledKey]),
          builder: (context, box, child) {
            return Column(
              children: [
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context)!.settingsMusic,
                    style: const TextStyle(color: Colors.white),
                  ),
                  value: box.get(bgmEnabledKey, defaultValue: true),
                  onChanged: (value) {
                    AudioManager.instance.toggleBgm();
                    AudioManager.instance.playSfx(AssetManager.sfxClick);
                  },
                  activeThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade700,
                ),
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context)!.settingsSfx,
                    style: const TextStyle(color: Colors.white),
                  ),
                  value: box.get(sfxEnabledKey, defaultValue: true),
                  onChanged: (value) {
                    AudioManager.instance.toggleSfx();
                    AudioManager.instance.playSfx(AssetManager.sfxClick);
                  },
                  activeThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade700,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),

        // This builder listens specifically to the language key to update the dropdown.
        ValueListenableBuilder(
          valueListenable: Hive.box(
            settingsBoxName,
          ).listenable(keys: [languageKey]),
          builder: (context, box, child) {
            final currentLangCode = box.get(languageKey, defaultValue: 'en');

            return MonochromeDropdown(
              value: currentLangCode,
              items: languages,
              onChanged: (newLangCode) {
                if (newLangCode != null) {
                  AudioManager.instance.playSfx(AssetManager.sfxClick);
                  box.put(languageKey, newLangCode);
                }
              },
            );
          },
        ),
      ],
    );
  }
}

class _AboutContent extends StatefulWidget {
  const _AboutContent();

  @override
  State<_AboutContent> createState() => __AboutContentState();
}

class __AboutContentState extends State<_AboutContent> {
  // A robust method to launch URLs with error handling.
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      // If launching fails, show a snackbar to the user.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade800,
            content: Text('Could not open link: $e'),
          ),
        );
      }
    }
  }

  // Helper widget for building a credit section with a title and icon.
  Widget _buildCreditSection({
    required IconData icon,
    required String title,
    required String credit,
    String? url, // Make the URL optional
  }) {
    // Determine if the section should be tappable.
    final bool isTappable = url != null && url.isNotEmpty;

    return InkWell(
      onTap: isTappable ? () => _launchURL(url) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      credit,
                      style: TextStyle(
                        color: isTappable
                            ? Colors.blue.shade200
                            : Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                        // Add an underline to visually indicate it's a link.
                        decoration: isTappable
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: Colors.blue.shade200,
                      ),
                    ),
                  ),
                  // Show a link icon if it's tappable.
                  if (isTappable)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.open_in_new,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.aboutCreditsHeader,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Music Credits Section - Now with URL
          _buildCreditSection(
            icon: Icons.music_note_rounded,
            title: localizations.aboutMusicTitle,
            credit: localizations.aboutMusicCredit,
            url: localizations.aboutMusicUrl,
          ),
          const SizedBox(height: 24),

          // Sound Effects Credits Section - Now with URL
          _buildCreditSection(
            icon: Icons.volume_up_rounded,
            title: localizations.aboutSfxTitle,
            credit: localizations.aboutSfxCredit,
            url: localizations.aboutSfxUrl,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
