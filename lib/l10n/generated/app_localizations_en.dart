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

  @override
  String get battleAttack => 'Attack';

  @override
  String get battleSkill => 'Skill';

  @override
  String get battleWin => 'Win';

  @override
  String get battleStart => 'Battle Start!';

  @override
  String get battleVictory => 'VICTORY!';

  @override
  String get battleDefeat => 'DEFEAT!';

  @override
  String get battleContinue => 'Continue';

  @override
  String get battleReturn => 'Return';

  @override
  String battlePlayerAttacks(String playerName, int damage) {
    return '$playerName attacks for $damage damage!';
  }

  @override
  String battlePlayerUsesSkill(
    String playerName,
    String skillName,
    int damage,
  ) {
    return '$playerName uses $skillName for $damage damage!';
  }

  @override
  String battlePlayerHeals(String playerName, int amount) {
    return '$playerName heals for $amount HP!';
  }

  @override
  String battleEnemyAttacks(String enemyName, int damage) {
    return '$enemyName attacks for $damage damage!';
  }

  @override
  String battleEnemyUsesSkill(String enemyName, String skillName, int damage) {
    return '$enemyName uses $skillName for $damage damage!';
  }

  @override
  String battleVictoryMessage(String enemyName) {
    return 'Victory! $enemyName has been defeated!';
  }

  @override
  String get battleDefeatMessage => 'Defeat! You have been defeated...';

  @override
  String get battleSurrendered => 'You surrendered...';

  @override
  String get skillSelectTitle => 'SELECT SKILL';

  @override
  String get skillCancel => 'CANCEL';

  @override
  String get skillAttack => 'ATTACK';

  @override
  String skillCost(int cost) {
    return 'Cost: $cost MP';
  }

  @override
  String get skillCostLabel => 'Cost';

  @override
  String get skillDamageLabel => 'Damage';

  @override
  String get skillHealLabel => 'Heal';

  @override
  String skillEstimatedDamage(int damage) {
    return '~$damage';
  }

  @override
  String get notEnoughMP => 'Not enough MP';

  @override
  String get skillFireballName => 'Fireball';

  @override
  String get skillFireballDesc =>
      'Launch a blazing fireball Deals 150% skill damage';

  @override
  String get skillIceSpearName => 'Ice Spear';

  @override
  String get skillIceSpearDesc =>
      'Pierce with frozen spear Deals 120% skill damage';

  @override
  String get skillThunderStrikeName => 'Thunder Strike';

  @override
  String get skillThunderStrikeDesc =>
      'Call down lightning Deals 200% skill damage';

  @override
  String get skillQuickStrikeName => 'Quick Strike';

  @override
  String get skillQuickStrikeDesc =>
      'Swift precise attack Deals 100% skill damage';

  @override
  String get skillHealingLightName => 'Healing Light';

  @override
  String get skillHealingLightDesc => 'Restore your vitality Heals 30 HP';

  @override
  String get floorChoosePath => 'CHOOSE YOUR PATH';

  @override
  String get floorMonster => 'Monster';

  @override
  String get floorMonsterDesc => 'Fight a monster and earn rewards';

  @override
  String get floorShop => 'Shop';

  @override
  String get floorShopDesc => 'Buy items with your gold';

  @override
  String get floorRest => 'Rest';

  @override
  String get floorRestDesc => 'Restore HP and manage inventory';

  @override
  String get floorBoss => 'Boss';

  @override
  String get floorBossDesc => 'Face the floor boss for massive rewards';

  @override
  String get floorStatus => 'STATUS';

  @override
  String get floorItem => 'ITEM';

  @override
  String floorNumber(int floor) {
    return 'FLOOR $floor';
  }

  @override
  String get restingStatus => 'Status';

  @override
  String get restingItem => 'Item';

  @override
  String get restingResting => 'Resting';

  @override
  String get restingNextFloor => 'Next Floor';

  @override
  String get restingFinishDungeon => 'Finish Dungeon';

  @override
  String get restingHp => 'HP';

  @override
  String get restingXp => 'XP';

  @override
  String get restingAttack => 'Attack';

  @override
  String get restingSkill => 'Skill';

  @override
  String get restingGold => 'Gold';

  @override
  String get restingFloor => 'Floor';

  @override
  String get restingDungeonInfo => 'Dungeon Info';

  @override
  String get restingNoItems => 'No items in inventory';

  @override
  String get restingUse => 'Use';

  @override
  String get shopTitle => 'Shop';

  @override
  String shopGold(int gold) {
    return 'Gold: $gold';
  }

  @override
  String get shopBuy => 'BUY';

  @override
  String get shopNotEnoughGold => 'NOT ENOUGH GOLD';

  @override
  String get shopOwnedLabel => 'OWNED';

  @override
  String get shopAlreadyOwned => 'You already own this upgrade!';

  @override
  String get shopNextFloor => 'Next Floor';

  @override
  String shopPrice(int price) {
    return '${price}G';
  }

  @override
  String get itemHealthPotionName => 'Health Potion';

  @override
  String get itemHealthPotionDesc => 'Restores 50 HP';

  @override
  String get itemSuperHealthPotionName => 'Super Health Potion';

  @override
  String get itemSuperHealthPotionDesc => 'Restores 100 HP';

  @override
  String get itemAttackScrollName => 'Attack Scroll';

  @override
  String get itemAttackScrollDesc => 'Permanently increases Attack by 5';

  @override
  String get itemSkillScrollName => 'Skill Scroll';

  @override
  String get itemSkillScrollDesc => 'Permanently increases Skill by 5';

  @override
  String get itemDefenseScrollName => 'Defense Scroll';

  @override
  String get itemDefenseScrollDesc => 'Permanently increases Defense by 5';

  @override
  String get itemGrandAttackScrollName => 'Blade Manual';

  @override
  String get itemGrandAttackScrollDesc => 'Permanently increases Attack by 10';

  @override
  String get itemFocusScrollName => 'Focus Scroll';

  @override
  String get itemFocusScrollDesc => 'Permanently increases Skill by 8';

  @override
  String get itemMpPotionName => 'MP Potion';

  @override
  String get itemMpPotionDesc => 'Restores 50 MP';

  @override
  String battlePlayerRestoresMp(String playerName, int amount) {
    return '$playerName restores $amount MP!';
  }

  @override
  String get statUpgradeTitle => 'LEVEL UP!';

  @override
  String statUpgradeLevel(int level) {
    return 'Level $level';
  }

  @override
  String statUpgradePointsAvailable(int points) {
    return 'Points Available: $points';
  }

  @override
  String get statUpgradeMaxHp => 'Max HP';

  @override
  String get statUpgradeMaxMp => 'Max MP';

  @override
  String get statUpgradeAttack => 'Attack';

  @override
  String get statUpgradeSkill => 'Skill';

  @override
  String get statUpgradeDefense => 'Defense';

  @override
  String get statUpgradeConfirm => 'Confirm';

  @override
  String get statUpgradeAllocateAll =>
      'You must allocate all points before continuing';

  @override
  String get restingDefense => 'Defense';

  @override
  String get floorDefense => 'Defense';
}
