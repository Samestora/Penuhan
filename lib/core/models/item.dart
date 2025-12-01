import 'package:flutter/material.dart';
import 'package:penuhan/l10n/generated/app_localizations.dart';

enum ItemType { potion, equipment, consumable }

class Item {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final int? hpRestore;
  final int? mpRestore;
  final int? attackBoost;
  final int? skillBoost;
  final int? defenseBoost;

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.hpRestore,
    this.mpRestore,
    this.attackBoost,
    this.skillBoost,
    this.defenseBoost,
  });

  // Check if item is a stat boost (passive) item
  bool get isPassiveBoost =>
      attackBoost != null || skillBoost != null || defenseBoost != null;

  // Check if item is a usable consumable (potion)
  bool get isConsumable => hpRestore != null || mpRestore != null;

  // Get localized name
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case 'health_potion':
        return l10n.itemHealthPotionName;
      case 'super_health_potion':
        return l10n.itemSuperHealthPotionName;
      case 'mp_potion':
        return l10n.itemMpPotionName;
      case 'attack_scroll':
        return l10n.itemAttackScrollName;
      case 'skill_scroll':
        return l10n.itemSkillScrollName;
      case 'defense_scroll':
        return l10n.itemDefenseScrollName;
      case 'grand_attack_scroll':
        return l10n.itemGrandAttackScrollName;
      case 'focus_scroll':
        return l10n.itemFocusScrollName;
      default:
        return name;
    }
  }

  // Get localized description
  String getLocalizedDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case 'health_potion':
        return l10n.itemHealthPotionDesc;
      case 'super_health_potion':
        return l10n.itemSuperHealthPotionDesc;
      case 'mp_potion':
        return l10n.itemMpPotionDesc;
      case 'attack_scroll':
        return l10n.itemAttackScrollDesc;
      case 'skill_scroll':
        return l10n.itemSkillScrollDesc;
      case 'defense_scroll':
        return l10n.itemDefenseScrollDesc;
      case 'grand_attack_scroll':
        return l10n.itemGrandAttackScrollDesc;
      case 'focus_scroll':
        return l10n.itemFocusScrollDesc;
      default:
        return description;
    }
  }

  // Predefined items
  static const healthPotion = Item(
    id: 'health_potion',
    name: 'Health Potion',
    description: 'Restores 50 HP',
    type: ItemType.potion,
    hpRestore: 50,
  );

  static const superHealthPotion = Item(
    id: 'super_health_potion',
    name: 'Super Health Potion',
    description: 'Restores 100 HP',
    type: ItemType.potion,
    hpRestore: 100,
  );

  static const mpPotion = Item(
    id: 'mp_potion',
    name: 'MP Potion',
    description: 'Restores 50 MP',
    type: ItemType.potion,
    mpRestore: 50,
  );

  static const attackScroll = Item(
    id: 'attack_scroll',
    name: 'Attack Scroll',
    description: 'Permanently increases Attack by 5',
    type: ItemType.consumable,
    attackBoost: 5,
  );

  static const skillScroll = Item(
    id: 'skill_scroll',
    name: 'Skill Scroll',
    description: 'Permanently increases Skill by 5',
    type: ItemType.consumable,
    skillBoost: 5,
  );

  static const defenseScroll = Item(
    id: 'defense_scroll',
    name: 'Defense Scroll',
    description: 'Permanently increases Defense by 5',
    type: ItemType.consumable,
    defenseBoost: 5,
  );

  static const grandAttackScroll = Item(
    id: 'grand_attack_scroll',
    name: 'Blade Manual',
    description: 'Permanently increases Attack by 10',
    type: ItemType.consumable,
    attackBoost: 10,
  );

  static const focusScroll = Item(
    id: 'focus_scroll',
    name: 'Focus Scroll',
    description: 'Permanently increases Skill by 8',
    type: ItemType.consumable,
    skillBoost: 8,
  );

  // List of all items for lookup
  static const allItems = [
    healthPotion,
    superHealthPotion,
    mpPotion,
    attackScroll,
    skillScroll,
    defenseScroll,
    grandAttackScroll,
    focusScroll,
  ];
}

class ShopItem {
  final Item item;
  final int price;

  const ShopItem({required this.item, required this.price});

  // Shop inventory
  static const shopItems = [
    ShopItem(item: Item.healthPotion, price: 20),
    ShopItem(item: Item.superHealthPotion, price: 50),
    ShopItem(item: Item.mpPotion, price: 40),
    ShopItem(item: Item.attackScroll, price: 100),
    ShopItem(item: Item.skillScroll, price: 100),
    ShopItem(item: Item.defenseScroll, price: 120),
    ShopItem(item: Item.grandAttackScroll, price: 200),
    ShopItem(item: Item.focusScroll, price: 180),
  ];
}

class InventoryItem {
  final String itemId;
  int quantity;

  InventoryItem({required this.itemId, this.quantity = 1});

  InventoryItem copyWith({int? quantity}) {
    return InventoryItem(itemId: itemId, quantity: quantity ?? this.quantity);
  }
}
