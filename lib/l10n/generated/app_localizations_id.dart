// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get mainMenuEmbark => 'Mulai';

  @override
  String get mainMenuSettings => 'Pengaturan';

  @override
  String get mainMenuAbout => 'Tentang';

  @override
  String get copyrightNotice => '© 2025 Soedirman Game Dev Community';

  @override
  String get settingsMusic => 'Musik';

  @override
  String get settingsSfx => 'Efek Suara';

  @override
  String get aboutCreditsTitle => 'Kredit & Apresiasi';

  @override
  String get aboutCreditsHeader =>
      'Terima kasih khusus kepada para kreator yang karya luar biasanya telah mewujudkan game ini:';

  @override
  String get aboutMusicTitle => 'Musik';

  @override
  String get aboutMusicCredit =>
      'BGM \"Main Menu\" oleh: 甘茶の音楽工房\n(Amacha Music Studio)';

  @override
  String get aboutMusicUrl => 'https://amachamusic.chagasi.com/';

  @override
  String get aboutSfxTitle => 'Efek Suara';

  @override
  String get aboutSfxCredit => 'Disediakan oleh: freesfx.co.uk';

  @override
  String get aboutSfxUrl => 'https://www.freesfx.co.uk/';

  @override
  String get embarkNewGame => 'Mulai';

  @override
  String get embarkContinue => 'lanjutkan';

  @override
  String get embarkEmpty => 'Kosong';

  @override
  String embarkSlot(int slotNumber) {
    return 'Slot $slotNumber';
  }

  @override
  String embarkLastSaved(String dateTime) {
    return 'Terakhir Disimpan: $dateTime';
  }

  @override
  String get embarkLoadFromDisk => 'Muat dari Disk';

  @override
  String get embarkSaveToDisk => 'Simpan ke Disk';
}
