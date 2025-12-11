import 'package:flutter/material.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';

class Skill {
  final String id;
  final String name;
  final String description;
  final int skillCost; // Cost in skill points
  final int
  damageMultiplier; // Multiplier for skill stat (e.g., 150 = 1.5x damage)
  final int? fixedDamage; // Optional fixed damage
  final SkillEffect? effect;
  final String? sfxPath; // SFX file path
  final String? animationPath; // Animation file path

  const Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.skillCost,
    required this.damageMultiplier,
    this.fixedDamage,
    this.effect,
    this.sfxPath,
    this.animationPath,
  });

  // Get localized name
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case 'fireball':
        return l10n.skillFireballName;
      case 'ice_spear':
        return l10n.skillIceSpearName;
      case 'thunder_strike':
        return l10n.skillThunderStrikeName;
      case 'quick_strike':
        return l10n.skillQuickStrikeName;
      case 'healing_light':
        return l10n.skillHealingLightName;
      default:
        return name;
    }
  }

  // Get localized description
  String getLocalizedDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case 'fireball':
        return l10n.skillFireballDesc;
      case 'ice_spear':
        return l10n.skillIceSpearDesc;
      case 'thunder_strike':
        return l10n.skillThunderStrikeDesc;
      case 'quick_strike':
        return l10n.skillQuickStrikeDesc;
      case 'healing_light':
        return l10n.skillHealingLightDesc;
      default:
        return description;
    }
  }

  // Calculate damage based on player's skill stat
  int calculateDamage(int playerSkillStat) {
    if (fixedDamage != null) {
      return fixedDamage!;
    }
    return (playerSkillStat * damageMultiplier / 100).round();
  }

  // Predefined skills
  static const fireball = Skill(
    id: 'fireball',
    name: 'Fireball',
    description: 'Launch a blazing fireball\nDeals 150% skill damage',
    skillCost: 10,
    damageMultiplier: 150,
    sfxPath: 'assets/audio/sfx/sfx_skill_fireball.wav',
    animationPath: 'assets/anim/fireball_effect.gif',
  );

  static const iceSpear = Skill(
    id: 'ice_spear',
    name: 'Ice Spear',
    description: 'Pierce with frozen spear\nDeals 120% skill damage',
    skillCost: 8,
    damageMultiplier: 120,
    sfxPath: 'assets/audio/sfx/sfx_skill_ice.wav',
    animationPath: 'assets/anim/ice.gif',
  );

  static const thunderStrike = Skill(
    id: 'thunder_strike',
    name: 'Thunder Strike',
    description: 'Call down lightning\nDeals 200% skill damage',
    skillCost: 15,
    damageMultiplier: 200,
    sfxPath: 'assets/audio/sfx/sfx_skill_thunder.wav',
    animationPath: 'assets/anim/thunder.gif',
  );

  static const quickStrike = Skill(
    id: 'quick_strike',
    name: 'Quick Strike',
    description: 'Swift precise attack\nDeals 100% skill damage',
    skillCost: 5,
    damageMultiplier: 100,
    sfxPath: 'assets/audio/sfx/sfx_skill_slash.wav',
    animationPath: 'assets/anim/slash_effect.gif',
  );

  static const healingLight = Skill(
    id: 'healing_light',
    name: 'Healing Light',
    description: 'Restore your vitality\nHeals 30 HP',
    skillCost: 12,
    damageMultiplier: 0,
    fixedDamage: 0,
    effect: SkillEffect.heal,
    sfxPath: 'assets/audio/sfx/sfx_skill_heal.wav',
    animationPath: 'assets/anim/heal_effect.gif',
  );

  // List of all available skills
  static const allSkills = [
    quickStrike,
    fireball,
    iceSpear,
    thunderStrike,
    healingLight,
  ];
}

enum SkillEffect {
  heal,
  // Can add more effects like: stun, poison, buff, etc.
}
