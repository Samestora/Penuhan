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

  @override
  String get sunkenCitadelName => 'Benteng Bawah Air';

  @override
  String get whisperingCryptName => 'Kuburan';

  @override
  String get dragonsMawName => 'Mulut Naga';

  @override
  String get easyDifficultyName => 'Mudah';

  @override
  String get normalDifficultyName => 'Biasa';

  @override
  String get hardDifficultyName => 'Sulit';

  @override
  String get battleAttack => 'Serang';

  @override
  String get battleSkill => 'Skill';

  @override
  String get battleWin => 'Menyerah';

  @override
  String get battleStart => 'Pertempuran Dimulai!';

  @override
  String get battleVictory => 'MENANG!';

  @override
  String get battleDefeat => 'KALAH!';

  @override
  String get battleContinue => 'Lanjutkan';

  @override
  String get battleReturn => 'Kembali';

  @override
  String battlePlayerAttacks(String playerName, int damage) {
    return '$playerName menyerang dengan $damage damage!';
  }

  @override
  String battlePlayerUsesSkill(
    String playerName,
    String skillName,
    int damage,
  ) {
    return '$playerName menggunakan $skillName dengan $damage damage!';
  }

  @override
  String battlePlayerHeals(String playerName, int amount) {
    return '$playerName memulihkan $amount HP!';
  }

  @override
  String battleEnemyAttacks(String enemyName, int damage) {
    return '$enemyName menyerang dengan $damage damage!';
  }

  @override
  String battleEnemyUsesSkill(String enemyName, String skillName, int damage) {
    return '$enemyName menggunakan $skillName dengan $damage damage!';
  }

  @override
  String battleEnemyHeals(String enemyName, int amount) {
    return '$enemyName memulihkan $amount HP!';
  }

  @override
  String battleVictoryMessage(String enemyName) {
    return 'Menang! $enemyName telah dikalahkan!';
  }

  @override
  String get battleDefeatMessage => 'Kalah! Kamu telah dikalahkan...';

  @override
  String get battleSurrendered => 'Kamu menyerah...';

  @override
  String get skillSelectTitle => 'PILIH SKILL';

  @override
  String get skillCancel => 'BATAL';

  @override
  String get skillAttack => 'SERANG';

  @override
  String skillCost(int cost) {
    return 'Biaya: $cost MP';
  }

  @override
  String get skillCostLabel => 'Biaya';

  @override
  String get skillDamageLabel => 'Damage';

  @override
  String get skillHealLabel => 'Heal';

  @override
  String skillEstimatedDamage(int damage) {
    return '~$damage';
  }

  @override
  String get notEnoughMP => 'MP tidak cukup';

  @override
  String get skillFireballName => 'Bola Api';

  @override
  String get skillFireballDesc =>
      'Luncurkan bola api yang membara Memberikan 150% skill damage';

  @override
  String get skillIceSpearName => 'Tombak Es';

  @override
  String get skillIceSpearDesc =>
      'Tusuk dengan tombak beku Memberikan 120% skill damage';

  @override
  String get skillThunderStrikeName => 'Sambaran Petir';

  @override
  String get skillThunderStrikeDesc =>
      'Panggil petir dari langit Memberikan 200% skill damage';

  @override
  String get skillQuickStrikeName => 'Serangan Cepat';

  @override
  String get skillQuickStrikeDesc =>
      'Serangan cepat dan presisi Memberikan 100% skill damage';

  @override
  String get skillHealingLightName => 'Cahaya Penyembuh';

  @override
  String get skillHealingLightDesc => 'Pulihkan vitalitasmu Memulihkan 30 HP';

  @override
  String get floorChoosePath => 'PILIH JALANMU';

  @override
  String get floorMonster => 'Monster';

  @override
  String get floorMonsterDesc => 'Lawan monster dan dapatkan hadiah';

  @override
  String get floorShop => 'Toko';

  @override
  String get floorShopDesc => 'Beli item dengan gold';

  @override
  String get floorRest => 'Istirahat';

  @override
  String get floorRestDesc => 'Pulihkan HP dan kelola inventory';

  @override
  String get floorBoss => 'Boss';

  @override
  String get floorBossDesc => 'Hadapi boss lantai untuk hadiah besar';

  @override
  String get floorStatus => 'STATUS';

  @override
  String get floorItem => 'ITEM';

  @override
  String floorNumber(int floor) {
    return 'LANTAI $floor';
  }

  @override
  String get restingStatus => 'Status';

  @override
  String get restingItem => 'Item';

  @override
  String get restingResting => 'Istirahat';

  @override
  String get restingNextFloor => 'Lantai Berikutnya';

  @override
  String get restingFinishDungeon => 'Selesaikan Dungeon';

  @override
  String get restingHp => 'HP';

  @override
  String get restingXp => 'XP';

  @override
  String get restingAttack => 'Serangan';

  @override
  String get restingSkill => 'Skill';

  @override
  String get restingGold => 'Gold';

  @override
  String get restingFloor => 'Lantai';

  @override
  String get restingDungeonInfo => 'Info Dungeon';

  @override
  String get restingNoItems => 'Tidak ada item di inventory';

  @override
  String get restingUse => 'Gunakan';

  @override
  String get shopTitle => 'Toko';

  @override
  String shopGold(int gold) {
    return 'Gold: $gold';
  }

  @override
  String get shopBuy => 'BELI';

  @override
  String get shopNotEnoughGold => 'GOLD TIDAK CUKUP';

  @override
  String get shopOwnedLabel => 'DIMILIKI';

  @override
  String get shopAlreadyOwned => 'Kamu sudah memiliki peningkatan ini!';

  @override
  String get shopNextFloor => 'Lantai Berikutnya';

  @override
  String shopPrice(int price) {
    return '${price}G';
  }

  @override
  String get itemHealthPotionName => 'Ramuan Kesehatan';

  @override
  String get itemHealthPotionDesc => 'Memulihkan 50 HP';

  @override
  String get itemSuperHealthPotionName => 'Ramuan Kesehatan Super';

  @override
  String get itemSuperHealthPotionDesc => 'Memulihkan 100 HP';

  @override
  String get itemAttackScrollName => 'Gulungan Serangan';

  @override
  String get itemAttackScrollDesc =>
      'Meningkatkan Serangan secara permanen sebesar 5';

  @override
  String get itemSkillScrollName => 'Gulungan Skill';

  @override
  String get itemSkillScrollDesc =>
      'Meningkatkan Skill secara permanen sebesar 5';

  @override
  String get itemDefenseScrollName => 'Gulungan Pertahanan';

  @override
  String get itemDefenseScrollDesc =>
      'Meningkatkan Pertahanan secara permanen sebesar 5';

  @override
  String get itemGrandAttackScrollName => 'Manual Pedang';

  @override
  String get itemGrandAttackScrollDesc =>
      'Meningkatkan Serangan secara permanen sebesar 10';

  @override
  String get itemFocusScrollName => 'Gulungan Fokus';

  @override
  String get itemFocusScrollDesc =>
      'Meningkatkan Skill secara permanen sebesar 8';

  @override
  String get itemMpPotionName => 'Ramuan MP';

  @override
  String get itemMpPotionDesc => 'Memulihkan 50 MP';

  @override
  String battlePlayerRestoresMp(String playerName, int amount) {
    return '$playerName memulihkan $amount MP!';
  }

  @override
  String get statUpgradeTitle => 'NAIK LEVEL!';

  @override
  String statUpgradeLevel(int level) {
    return 'Level $level';
  }

  @override
  String statUpgradePointsAvailable(int points) {
    return 'Poin Tersedia: $points';
  }

  @override
  String get statUpgradeMaxHp => 'HP Maks';

  @override
  String get statUpgradeMaxMp => 'MP Maks';

  @override
  String get statUpgradeAttack => 'Serangan';

  @override
  String get statUpgradeSkill => 'Skill';

  @override
  String get statUpgradeDefense => 'Pertahanan';

  @override
  String get statUpgradeConfirm => 'Konfirmasi';

  @override
  String get statUpgradeAllocateAll =>
      'Anda harus mengalokasikan semua poin sebelum melanjutkan';

  @override
  String get restingDefense => 'Pertahanan';

  @override
  String get floorDefense => 'Pertahanan';

  @override
  String get pauseTitle => 'Jeda';

  @override
  String get pauseResume => 'Lanjutkan';

  @override
  String get pauseSave => 'Simpan';

  @override
  String get pauseSetting => 'Pengaturan';

  @override
  String get pauseMainMenu => 'Main Menu';

  @override
  String get pauseExitGame => 'Keluar Game';

  @override
  String get playerName => 'Pahlawan Tanpa Nama';

  @override
  String get saveGame => 'Simpan Permainan';

  @override
  String get loadGame => 'Muat Permainan';

  @override
  String get slot => 'Slot';

  @override
  String get emptySlot => 'Slot Kosong';

  @override
  String get save => 'Simpan';

  @override
  String get back => 'Kembali';

  @override
  String get overwriteSave => 'Timpa Simpanan?';

  @override
  String get overwriteSaveConfirm =>
      'Ini akan menimpa simpanan yang ada. Lanjutkan?';

  @override
  String get cancel => 'Batal';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get gameSaved => 'Permainan berhasil disimpan!';

  @override
  String get error => 'Kesalahan';
}
