// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get mainMenuEmbark => 'Embark';

  @override
  String get mainMenuSettings => 'Settings';

  @override
  String get mainMenuAbout => 'About';

  @override
  String get copyrightNotice => '© 2025 Soedirman Game Dev Community';

  @override
  String get settingsMusic => 'Music';

  @override
  String get settingsSfx => 'Sound Effects';

  @override
  String get aboutCreditsTitle => 'Credits & Appreciation';

  @override
  String get aboutCreditsHeader =>
      'Special thanks to the creators whose amazing work made this game possible:';

  @override
  String get aboutMusicTitle => 'Music';

  @override
  String get aboutMusicCredit =>
      '\"Main Menu\" BGM by: 甘茶の音楽工房\n(Amacha Music Studio)';

  @override
  String get aboutMusicUrl => 'https://amachamusic.chagasi.com/';

  @override
  String get aboutSfxTitle => 'Sound Effects';

  @override
  String get aboutSfxCredit => 'Provided by: freesfx.co.uk';

  @override
  String get aboutSfxUrl => 'https://www.freesfx.co.uk/';

  @override
  String get embarkNewGame => 'New Game';

  @override
  String get embarkContinue => 'Continue';

  @override
  String get embarkEmpty => 'Empty';

  @override
  String embarkSlot(int slotNumber) {
    return 'Slot $slotNumber';
  }

  @override
  String embarkLastSaved(String dateTime) {
    return 'Last saved: $dateTime';
  }

  @override
  String get embarkLoadFromDisk => 'Load from Disk';

  @override
  String get embarkSaveToDisk => 'Save to Disk';

  @override
  String get sunkenCitadelName => 'Sunken Citadel';

  @override
  String get whisperingCryptName => 'Whispering Crypts';

  @override
  String get dragonsMawName => 'Dragon\'s Maw';

  @override
  String get easyDifficultyName => 'Easy';

  @override
  String get normalDifficultyName => 'Normal';

  @override
  String get hardDifficultyName => 'Hard';
}
