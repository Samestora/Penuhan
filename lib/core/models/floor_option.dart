import 'dart:math';
import 'package:flutter/material.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';

enum FloorOptionType { battle, shop, rest }

class FloorOption {
  final FloorOptionType type;
  final String displayName;
  final String description;

  FloorOption({
    required this.type,
    required this.displayName,
    required this.description,
  });

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case FloorOptionType.battle:
        return l10n.floorMonster;
      case FloorOptionType.shop:
        return l10n.floorShop;
      case FloorOptionType.rest:
        return l10n.floorRest;
    }
  }

  String getLocalizedDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case FloorOptionType.battle:
        return l10n.floorMonsterDesc;
      case FloorOptionType.shop:
        return l10n.floorShopDesc;
      case FloorOptionType.rest:
        return l10n.floorRestDesc;
    }
  }

  static List<FloorOption> generateRandomOptions() {
    final random = Random();
    final optionCount = random.nextInt(3) + 1; // 1 to 3 options
    final availableTypes = List<FloorOptionType>.from(FloorOptionType.values);
    final selectedOptions = <FloorOption>[];

    // Shuffle and pick random types
    availableTypes.shuffle();

    for (int i = 0; i < optionCount && i < availableTypes.length; i++) {
      final type = availableTypes[i];
      selectedOptions.add(_createOption(type));
    }

    return selectedOptions;
  }

  static FloorOption _createOption(FloorOptionType type) {
    switch (type) {
      case FloorOptionType.battle:
        return FloorOption(
          type: FloorOptionType.battle,
          displayName: 'Monster',
          description: 'Fight a monster and earn rewards',
        );
      case FloorOptionType.shop:
        return FloorOption(
          type: FloorOptionType.shop,
          displayName: 'Shop',
          description: 'Buy items with your gold',
        );
      case FloorOptionType.rest:
        return FloorOption(
          type: FloorOptionType.rest,
          displayName: 'Rest',
          description: 'Restore HP and manage inventory',
        );
    }
  }
}
