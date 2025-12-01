import 'dart:math';
import 'package:flutter/material.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';

enum FloorOptionType { battle, shop, rest }

class FloorOption {
  final FloorOptionType type;
  final String displayName;
  final String description;
  final bool isBoss;

  /// Configuration for floor option probabilities.
  /// Battle nodes get the highest weight so they appear most often,
  /// while shop/rest remain possible but rarer. Update these weights to
  /// rebalance how many options appear and which types spawn.
  static const Map<int, int> _optionCountWeights = {
    1: 6, // Rarely single option
    2: 4, // Commonly two options
    3: 2, // Frequent chance for three options
  };

  static const Map<FloorOptionType, int> _optionTypeWeights = {
    FloorOptionType.battle: 6,
    FloorOptionType.rest: 2,
    FloorOptionType.shop: 3,
  };

  const FloorOption({
    required this.type,
    required this.displayName,
    required this.description,
    this.isBoss = false,
  });

  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isBoss && type == FloorOptionType.battle) {
      return l10n.floorBoss;
    }
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
    if (isBoss && type == FloorOptionType.battle) {
      return l10n.floorBossDesc;
    }
    switch (type) {
      case FloorOptionType.battle:
        return l10n.floorMonsterDesc;
      case FloorOptionType.shop:
        return l10n.floorShopDesc;
      case FloorOptionType.rest:
        return l10n.floorRestDesc;
    }
  }

  static List<FloorOption> generateRandomOptions({required int currentFloor}) {
    final random = Random();
    final isBossFloor = currentFloor > 0 && currentFloor % 10 == 0;
    if (isBossFloor) {
      return [_createOption(FloorOptionType.battle, isBoss: true)];
    }
    final optionCount = _pickWeightedOptionCount(random);
    final selectedOptions = <FloorOption>[];

    for (int i = 0; i < optionCount; i++) {
      final type = _pickWeightedOptionType(random);
      selectedOptions.add(_createOption(type));
    }

    if (selectedOptions.isEmpty) {
      selectedOptions.add(_createOption(FloorOptionType.battle));
    }

    final hasBattle = selectedOptions.any(
      (option) => option.type == FloorOptionType.battle,
    );
    if (!hasBattle) {
      final replaceIndex = random.nextInt(selectedOptions.length);
      selectedOptions[replaceIndex] = _createOption(FloorOptionType.battle);
    }

    return selectedOptions;
  }

  static int _pickWeightedOptionCount(Random random) {
    final totalWeight = _optionCountWeights.values.fold<int>(
      0,
      (sum, weight) => sum + weight,
    );
    var roll = random.nextInt(totalWeight) + 1;

    for (final entry in _optionCountWeights.entries) {
      roll -= entry.value;
      if (roll <= 0) {
        return entry.key;
      }
    }
    return 2; // Fallback
  }

  static FloorOptionType _pickWeightedOptionType(Random random) {
    final totalWeight = _optionTypeWeights.values.fold<int>(
      0,
      (sum, weight) => sum + weight,
    );
    var roll = random.nextInt(totalWeight) + 1;

    for (final entry in _optionTypeWeights.entries) {
      roll -= entry.value;
      if (roll <= 0) {
        return entry.key;
      }
    }
    return FloorOptionType.battle; // Fallback to monster
  }

  static FloorOption _createOption(
    FloorOptionType type, {
    bool isBoss = false,
  }) {
    switch (type) {
      case FloorOptionType.battle:
        return FloorOption(
          type: FloorOptionType.battle,
          displayName: isBoss ? 'Boss' : 'Monster',
          description: isBoss
              ? 'Face a boss for great rewards'
              : 'Fight a monster and earn rewards',
          isBoss: isBoss,
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
