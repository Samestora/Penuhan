import 'package:flutter/material.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';
import 'package:penuhan/models/dungeon.dart';

/// Extension to get the localized name for a [DungeonDifficulty].
/// ```dart
/// dungeon.difficulty.getName(context),
///  ```
extension DifficultyLocalization on DungeonDifficulty {
  String getName(BuildContext context) {
    // Get the AppLocalizations instance once.
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case DungeonDifficulty.easy:
        return l10n.easyDifficultyName;
      case DungeonDifficulty.normal:
        return l10n.normalDifficultyName;
      case DungeonDifficulty.hard:
        return l10n.hardDifficultyName;
    }
  }
}

/// Extension to get the localized name for a [DungeonName].
/// /// ```dart
/// DungeonName.sunkenCitadel.getName(context),
///  ```
extension DungeonLocalization on DungeonName {
  String getName(BuildContext context) {
    // Get the AppLocalizations instance once.
    final l10n = AppLocalizations.of(context)!;

    switch (this) {
      case DungeonName.sunkenCitadel:
        return l10n.sunkenCitadelName;
      case DungeonName.dragonsMaw:
        return l10n.dragonsMawName;
      case DungeonName.whisperingCrypt:
        return l10n.whisperingCryptName;
    }
  }
}
