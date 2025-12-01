import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:penuhan/core/utils/asset_manager.dart';
import 'package:penuhan/core/utils/audio_manager.dart';
import 'package:penuhan/core/utils/hive_constants.dart';
import 'package:penuhan/core/widgets/monochrome_dropdown.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  final Map<String, String> _allLanguages = const {
    'en': 'English',
    'id': 'Bahasa Indonesia',
  };

  @override
  Widget build(BuildContext context) {
    final audioManager = context.watch<AudioManager>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Audio toggles
        ValueListenableBuilder(
          valueListenable: Hive.box(
            settingsBoxName,
          ).listenable(keys: [bgmEnabledKey, sfxEnabledKey]),
          builder: (context, box, child) {
            return Column(
              children: [
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.settingsMusic),
                  value: box.get(bgmEnabledKey, defaultValue: true),
                  onChanged: (value) {
                    audioManager.toggleBgm();
                    audioManager.playSfx(AssetManager.sfxClick);
                  },
                  activeThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade700,
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.settingsSfx),
                  value: box.get(sfxEnabledKey, defaultValue: true),
                  onChanged: (value) {
                    audioManager.toggleSfx();
                    audioManager.playSfx(AssetManager.sfxClick);
                  },
                  activeThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey.shade700,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),

        // Language dropdown
        ValueListenableBuilder(
          valueListenable: Hive.box(
            settingsBoxName,
          ).listenable(keys: [languageKey]),
          builder: (context, box, child) {
            final currentLangCode = box.get(languageKey, defaultValue: 'en');
            final Map<String, String> orderedLanguages = {};
            if (_allLanguages.containsKey(currentLangCode)) {
              orderedLanguages[currentLangCode] =
                  _allLanguages[currentLangCode]!;
            }
            _allLanguages.forEach((key, value) {
              if (key != currentLangCode) {
                orderedLanguages[key] = value;
              }
            });

            return MonochromeDropdown(
              value: currentLangCode,
              items: orderedLanguages,
              onChanged: (newLangCode) {
                if (newLangCode != null) {
                  audioManager.playSfx(AssetManager.sfxClick);
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
