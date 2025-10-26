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
