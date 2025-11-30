import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// The main button to start a new game
  ///
  /// In en, this message translates to:
  /// **'Embark'**
  String get mainMenuEmbark;

  /// For the settings button in main menu
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get mainMenuSettings;

  /// For the about button in main menu
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get mainMenuAbout;

  /// Putranto Surya Wijanarko & Raden Demas Amirul Plawirakusumah
  ///
  /// In en, this message translates to:
  /// **'© 2025 Soedirman Game Dev Community'**
  String get copyrightNotice;

  /// Toggling music in settings
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get settingsMusic;

  /// Toggling sound effects in settings
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get settingsSfx;

  /// Title for the credits section
  ///
  /// In en, this message translates to:
  /// **'Credits & Appreciation'**
  String get aboutCreditsTitle;

  /// Header for the credits section
  ///
  /// In en, this message translates to:
  /// **'Special thanks to the creators whose amazing work made this game possible:'**
  String get aboutCreditsHeader;

  /// Title for the music section
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get aboutMusicTitle;

  /// Credit for the music in the game
  ///
  /// In en, this message translates to:
  /// **'\"Main Menu\" BGM by: 甘茶の音楽工房\n(Amacha Music Studio)'**
  String get aboutMusicCredit;

  /// URL for the music creator's website
  ///
  /// In en, this message translates to:
  /// **'https://amachamusic.chagasi.com/'**
  String get aboutMusicUrl;

  /// Title for the sound effects section
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get aboutSfxTitle;

  /// Credit for the sound effects in the game
  ///
  /// In en, this message translates to:
  /// **'Provided by: freesfx.co.uk'**
  String get aboutSfxCredit;

  /// URL for the sound effects website
  ///
  /// In en, this message translates to:
  /// **'https://www.freesfx.co.uk/'**
  String get aboutSfxUrl;

  /// No description provided for @embarkNewGame.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get embarkNewGame;

  /// No description provided for @embarkContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get embarkContinue;

  /// No description provided for @embarkEmpty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get embarkEmpty;

  /// Label for a save slot, e.g., 'Slot 1'
  ///
  /// In en, this message translates to:
  /// **'Slot {slotNumber}'**
  String embarkSlot(int slotNumber);

  /// Shows the last time the game was saved
  ///
  /// In en, this message translates to:
  /// **'Last saved: {dateTime}'**
  String embarkLastSaved(String dateTime);

  /// No description provided for @embarkLoadFromDisk.
  ///
  /// In en, this message translates to:
  /// **'Load from Disk'**
  String get embarkLoadFromDisk;

  /// No description provided for @embarkSaveToDisk.
  ///
  /// In en, this message translates to:
  /// **'Save to Disk'**
  String get embarkSaveToDisk;

  /// Name of the Sunken Citadel dungeon
  ///
  /// In en, this message translates to:
  /// **'Sunken Citadel'**
  String get sunkenCitadelName;

  /// Name of the Whispering Crypts dungeon
  ///
  /// In en, this message translates to:
  /// **'Whispering Crypts'**
  String get whisperingCryptName;

  /// Name of the Dragon's Maw dungeon
  ///
  /// In en, this message translates to:
  /// **'Dragon\'s Maw'**
  String get dragonsMawName;

  /// No description provided for @easyDifficultyName.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easyDifficultyName;

  /// No description provided for @normalDifficultyName.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normalDifficultyName;

  /// No description provided for @hardDifficultyName.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hardDifficultyName;

  /// No description provided for @battleAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get battleAttack;

  /// No description provided for @battleSkill.
  ///
  /// In en, this message translates to:
  /// **'Skill'**
  String get battleSkill;

  /// No description provided for @battleWin.
  ///
  /// In en, this message translates to:
  /// **'Win'**
  String get battleWin;

  /// No description provided for @battleStart.
  ///
  /// In en, this message translates to:
  /// **'Battle Start!'**
  String get battleStart;

  /// No description provided for @battleVictory.
  ///
  /// In en, this message translates to:
  /// **'VICTORY!'**
  String get battleVictory;

  /// No description provided for @battleDefeat.
  ///
  /// In en, this message translates to:
  /// **'DEFEAT!'**
  String get battleDefeat;

  /// No description provided for @battleContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get battleContinue;

  /// No description provided for @battleReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get battleReturn;

  /// No description provided for @battlePlayerAttacks.
  ///
  /// In en, this message translates to:
  /// **'{playerName} attacks for {damage} damage!'**
  String battlePlayerAttacks(String playerName, int damage);

  /// No description provided for @battlePlayerUsesSkill.
  ///
  /// In en, this message translates to:
  /// **'{playerName} uses {skillName} for {damage} damage!'**
  String battlePlayerUsesSkill(String playerName, String skillName, int damage);

  /// No description provided for @battlePlayerHeals.
  ///
  /// In en, this message translates to:
  /// **'{playerName} heals for {amount} HP!'**
  String battlePlayerHeals(String playerName, int amount);

  /// No description provided for @battleEnemyAttacks.
  ///
  /// In en, this message translates to:
  /// **'{enemyName} attacks for {damage} damage!'**
  String battleEnemyAttacks(String enemyName, int damage);

  /// No description provided for @battleEnemyUsesSkill.
  ///
  /// In en, this message translates to:
  /// **'{enemyName} uses {skillName} for {damage} damage!'**
  String battleEnemyUsesSkill(String enemyName, String skillName, int damage);

  /// No description provided for @battleVictoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Victory! {enemyName} has been defeated!'**
  String battleVictoryMessage(String enemyName);

  /// No description provided for @battleDefeatMessage.
  ///
  /// In en, this message translates to:
  /// **'Defeat! You have been defeated...'**
  String get battleDefeatMessage;

  /// No description provided for @battleSurrendered.
  ///
  /// In en, this message translates to:
  /// **'You surrendered...'**
  String get battleSurrendered;

  /// No description provided for @skillSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'SELECT SKILL'**
  String get skillSelectTitle;

  /// No description provided for @skillCancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get skillCancel;

  /// No description provided for @skillAttack.
  ///
  /// In en, this message translates to:
  /// **'ATTACK'**
  String get skillAttack;

  /// No description provided for @skillCost.
  ///
  /// In en, this message translates to:
  /// **'Cost: {cost} MP'**
  String skillCost(int cost);

  /// No description provided for @skillCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get skillCostLabel;

  /// No description provided for @skillDamageLabel.
  ///
  /// In en, this message translates to:
  /// **'Damage'**
  String get skillDamageLabel;

  /// No description provided for @skillHealLabel.
  ///
  /// In en, this message translates to:
  /// **'Heal'**
  String get skillHealLabel;

  /// No description provided for @skillEstimatedDamage.
  ///
  /// In en, this message translates to:
  /// **'~{damage}'**
  String skillEstimatedDamage(int damage);

  /// No description provided for @notEnoughMP.
  ///
  /// In en, this message translates to:
  /// **'Not enough MP'**
  String get notEnoughMP;

  /// No description provided for @skillFireballName.
  ///
  /// In en, this message translates to:
  /// **'Fireball'**
  String get skillFireballName;

  /// No description provided for @skillFireballDesc.
  ///
  /// In en, this message translates to:
  /// **'Launch a blazing fireball Deals 150% skill damage'**
  String get skillFireballDesc;

  /// No description provided for @skillIceSpearName.
  ///
  /// In en, this message translates to:
  /// **'Ice Spear'**
  String get skillIceSpearName;

  /// No description provided for @skillIceSpearDesc.
  ///
  /// In en, this message translates to:
  /// **'Pierce with frozen spear Deals 120% skill damage'**
  String get skillIceSpearDesc;

  /// No description provided for @skillThunderStrikeName.
  ///
  /// In en, this message translates to:
  /// **'Thunder Strike'**
  String get skillThunderStrikeName;

  /// No description provided for @skillThunderStrikeDesc.
  ///
  /// In en, this message translates to:
  /// **'Call down lightning Deals 200% skill damage'**
  String get skillThunderStrikeDesc;

  /// No description provided for @skillQuickStrikeName.
  ///
  /// In en, this message translates to:
  /// **'Quick Strike'**
  String get skillQuickStrikeName;

  /// No description provided for @skillQuickStrikeDesc.
  ///
  /// In en, this message translates to:
  /// **'Swift precise attack Deals 100% skill damage'**
  String get skillQuickStrikeDesc;

  /// No description provided for @skillHealingLightName.
  ///
  /// In en, this message translates to:
  /// **'Healing Light'**
  String get skillHealingLightName;

  /// No description provided for @skillHealingLightDesc.
  ///
  /// In en, this message translates to:
  /// **'Restore your vitality Heals 30 HP'**
  String get skillHealingLightDesc;

  /// No description provided for @floorChoosePath.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE YOUR PATH'**
  String get floorChoosePath;

  /// No description provided for @floorMonster.
  ///
  /// In en, this message translates to:
  /// **'Monster'**
  String get floorMonster;

  /// No description provided for @floorMonsterDesc.
  ///
  /// In en, this message translates to:
  /// **'Fight a monster and earn rewards'**
  String get floorMonsterDesc;

  /// No description provided for @floorShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get floorShop;

  /// No description provided for @floorShopDesc.
  ///
  /// In en, this message translates to:
  /// **'Buy items with your gold'**
  String get floorShopDesc;

  /// No description provided for @floorRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get floorRest;

  /// No description provided for @floorRestDesc.
  ///
  /// In en, this message translates to:
  /// **'Restore HP and manage inventory'**
  String get floorRestDesc;

  /// No description provided for @floorStatus.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get floorStatus;

  /// No description provided for @floorItem.
  ///
  /// In en, this message translates to:
  /// **'ITEM'**
  String get floorItem;

  /// No description provided for @floorNumber.
  ///
  /// In en, this message translates to:
  /// **'FLOOR {floor}'**
  String floorNumber(int floor);

  /// No description provided for @restingStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get restingStatus;

  /// No description provided for @restingItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get restingItem;

  /// No description provided for @restingResting.
  ///
  /// In en, this message translates to:
  /// **'Resting'**
  String get restingResting;

  /// No description provided for @restingNextFloor.
  ///
  /// In en, this message translates to:
  /// **'Next Floor'**
  String get restingNextFloor;

  /// No description provided for @restingFinishDungeon.
  ///
  /// In en, this message translates to:
  /// **'Finish Dungeon'**
  String get restingFinishDungeon;

  /// No description provided for @restingHp.
  ///
  /// In en, this message translates to:
  /// **'HP'**
  String get restingHp;

  /// No description provided for @restingXp.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get restingXp;

  /// No description provided for @restingAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get restingAttack;

  /// No description provided for @restingSkill.
  ///
  /// In en, this message translates to:
  /// **'Skill'**
  String get restingSkill;

  /// No description provided for @restingGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get restingGold;

  /// No description provided for @restingFloor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get restingFloor;

  /// No description provided for @restingDungeonInfo.
  ///
  /// In en, this message translates to:
  /// **'Dungeon Info'**
  String get restingDungeonInfo;

  /// No description provided for @restingNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items in inventory'**
  String get restingNoItems;

  /// No description provided for @restingUse.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get restingUse;

  /// No description provided for @shopTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopTitle;

  /// No description provided for @shopGold.
  ///
  /// In en, this message translates to:
  /// **'Gold: {gold}'**
  String shopGold(int gold);

  /// No description provided for @shopBuy.
  ///
  /// In en, this message translates to:
  /// **'BUY'**
  String get shopBuy;

  /// No description provided for @shopNotEnoughGold.
  ///
  /// In en, this message translates to:
  /// **'NOT ENOUGH GOLD'**
  String get shopNotEnoughGold;

  /// No description provided for @shopOwnedLabel.
  ///
  /// In en, this message translates to:
  /// **'OWNED'**
  String get shopOwnedLabel;

  /// No description provided for @shopAlreadyOwned.
  ///
  /// In en, this message translates to:
  /// **'You already own this upgrade!'**
  String get shopAlreadyOwned;

  /// No description provided for @shopNextFloor.
  ///
  /// In en, this message translates to:
  /// **'Next Floor'**
  String get shopNextFloor;

  /// No description provided for @shopPrice.
  ///
  /// In en, this message translates to:
  /// **'{price}G'**
  String shopPrice(int price);

  /// No description provided for @itemHealthPotionName.
  ///
  /// In en, this message translates to:
  /// **'Health Potion'**
  String get itemHealthPotionName;

  /// No description provided for @itemHealthPotionDesc.
  ///
  /// In en, this message translates to:
  /// **'Restores 50 HP'**
  String get itemHealthPotionDesc;

  /// No description provided for @itemSuperHealthPotionName.
  ///
  /// In en, this message translates to:
  /// **'Super Health Potion'**
  String get itemSuperHealthPotionName;

  /// No description provided for @itemSuperHealthPotionDesc.
  ///
  /// In en, this message translates to:
  /// **'Restores 100 HP'**
  String get itemSuperHealthPotionDesc;

  /// No description provided for @itemAttackScrollName.
  ///
  /// In en, this message translates to:
  /// **'Attack Scroll'**
  String get itemAttackScrollName;

  /// No description provided for @itemAttackScrollDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanently increases Attack by 5'**
  String get itemAttackScrollDesc;

  /// No description provided for @itemSkillScrollName.
  ///
  /// In en, this message translates to:
  /// **'Skill Scroll'**
  String get itemSkillScrollName;

  /// No description provided for @itemSkillScrollDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanently increases Skill by 5'**
  String get itemSkillScrollDesc;

  /// No description provided for @itemDefenseScrollName.
  ///
  /// In en, this message translates to:
  /// **'Defense Scroll'**
  String get itemDefenseScrollName;

  /// No description provided for @itemDefenseScrollDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanently increases Defense by 5'**
  String get itemDefenseScrollDesc;

  /// No description provided for @itemGrandAttackScrollName.
  ///
  /// In en, this message translates to:
  /// **'Blade Manual'**
  String get itemGrandAttackScrollName;

  /// No description provided for @itemGrandAttackScrollDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanently increases Attack by 10'**
  String get itemGrandAttackScrollDesc;

  /// No description provided for @itemFocusScrollName.
  ///
  /// In en, this message translates to:
  /// **'Focus Scroll'**
  String get itemFocusScrollName;

  /// No description provided for @itemFocusScrollDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanently increases Skill by 8'**
  String get itemFocusScrollDesc;

  /// No description provided for @itemMpPotionName.
  ///
  /// In en, this message translates to:
  /// **'MP Potion'**
  String get itemMpPotionName;

  /// No description provided for @itemMpPotionDesc.
  ///
  /// In en, this message translates to:
  /// **'Restores 50 MP'**
  String get itemMpPotionDesc;

  /// No description provided for @battlePlayerRestoresMp.
  ///
  /// In en, this message translates to:
  /// **'{playerName} restores {amount} MP!'**
  String battlePlayerRestoresMp(String playerName, int amount);

  /// No description provided for @statUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'LEVEL UP!'**
  String get statUpgradeTitle;

  /// No description provided for @statUpgradeLevel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String statUpgradeLevel(int level);

  /// No description provided for @statUpgradePointsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Points Available: {points}'**
  String statUpgradePointsAvailable(int points);

  /// No description provided for @statUpgradeMaxHp.
  ///
  /// In en, this message translates to:
  /// **'Max HP'**
  String get statUpgradeMaxHp;

  /// No description provided for @statUpgradeMaxMp.
  ///
  /// In en, this message translates to:
  /// **'Max MP'**
  String get statUpgradeMaxMp;

  /// No description provided for @statUpgradeAttack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get statUpgradeAttack;

  /// No description provided for @statUpgradeSkill.
  ///
  /// In en, this message translates to:
  /// **'Skill'**
  String get statUpgradeSkill;

  /// No description provided for @statUpgradeDefense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get statUpgradeDefense;

  /// No description provided for @statUpgradeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get statUpgradeConfirm;

  /// No description provided for @statUpgradeAllocateAll.
  ///
  /// In en, this message translates to:
  /// **'You must allocate all points before continuing'**
  String get statUpgradeAllocateAll;

  /// No description provided for @restingDefense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get restingDefense;

  /// No description provided for @floorDefense.
  ///
  /// In en, this message translates to:
  /// **'Defense'**
  String get floorDefense;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
