import 'item.dart';

class GameProgress {
  final int currentFloor;
  final int maxFloor;
  final int playerHp;
  final int playerMaxHp;
  final int playerXp;
  final int playerMaxXp;
  final int playerMp;
  final int playerMaxMp;
  final int playerAttack;
  final int playerSkill;
  final int gold;
  final List<InventoryItem> inventory;

  GameProgress({
    required this.currentFloor,
    required this.maxFloor,
    required this.playerHp,
    required this.playerMaxHp,
    required this.playerXp,
    required this.playerMaxXp,
    this.playerMp = 50,
    this.playerMaxMp = 50,
    required this.playerAttack,
    required this.playerSkill,
    this.gold = 0,
    this.inventory = const [],
  });

  GameProgress copyWith({
    int? currentFloor,
    int? maxFloor,
    int? playerHp,
    int? playerMaxHp,
    int? playerXp,
    int? playerMaxXp,
    int? playerMp,
    int? playerMaxMp,
    int? playerAttack,
    int? playerSkill,
    int? gold,
    List<InventoryItem>? inventory,
  }) {
    return GameProgress(
      currentFloor: currentFloor ?? this.currentFloor,
      maxFloor: maxFloor ?? this.maxFloor,
      playerHp: playerHp ?? this.playerHp,
      playerMaxHp: playerMaxHp ?? this.playerMaxHp,
      playerXp: playerXp ?? this.playerXp,
      playerMaxXp: playerMaxXp ?? this.playerMaxXp,
      playerMp: playerMp ?? this.playerMp,
      playerMaxMp: playerMaxMp ?? this.playerMaxMp,
      playerAttack: playerAttack ?? this.playerAttack,
      playerSkill: playerSkill ?? this.playerSkill,
      gold: gold ?? this.gold,
      inventory: inventory ?? this.inventory,
    );
  }

  // Helper untuk restore HP
  GameProgress restoreHp(int amount) {
    final newHp = (playerHp + amount).clamp(0, playerMaxHp);
    return copyWith(playerHp: newHp);
  }

  // Helper untuk restore MP
  GameProgress restoreMp(int amount) {
    final newMp = (playerMp + amount).clamp(0, playerMaxMp);
    return copyWith(playerMp: newMp);
  }

  // Helper untuk next floor
  GameProgress nextFloor() {
    return copyWith(currentFloor: currentFloor + 1);
  }

  // Helper untuk buy item
  GameProgress buyItem(Item item, int price) {
    if (gold < price) return this;

    final newInventory = List<InventoryItem>.from(inventory);
    final existingIndex = newInventory.indexWhere(
      (inv) => inv.itemId == item.id,
    );

    if (existingIndex >= 0) {
      newInventory[existingIndex] = newInventory[existingIndex].copyWith(
        quantity: newInventory[existingIndex].quantity + 1,
      );
    } else {
      newInventory.add(InventoryItem(itemId: item.id));
    }

    return copyWith(gold: gold - price, inventory: newInventory);
  }

  // Helper untuk use item
  GameProgress useItem(String itemId) {
    final itemIndex = inventory.indexWhere((inv) => inv.itemId == itemId);
    if (itemIndex < 0) return this;

    final inventoryItem = inventory[itemIndex];
    final item = Item.allItems.firstWhere((i) => i.id == itemId);

    var newProgress = this;

    // Apply item effects
    if (item.hpRestore != null) {
      newProgress = newProgress.restoreHp(item.hpRestore!);
    }
    if (item.mpRestore != null) {
      newProgress = newProgress.restoreMp(item.mpRestore!);
    }
    if (item.attackBoost != null) {
      newProgress = newProgress.copyWith(
        playerAttack: playerAttack + item.attackBoost!,
      );
    }
    if (item.skillBoost != null) {
      newProgress = newProgress.copyWith(
        playerSkill: playerSkill + item.skillBoost!,
      );
    }

    // Update inventory
    final newInventory = List<InventoryItem>.from(inventory);
    if (inventoryItem.quantity > 1) {
      newInventory[itemIndex] = inventoryItem.copyWith(
        quantity: inventoryItem.quantity - 1,
      );
    } else {
      newInventory.removeAt(itemIndex);
    }

    return newProgress.copyWith(inventory: newInventory);
  }

  // Helper untuk cek apakah punya item
  bool hasItem(String itemId) {
    return inventory.any((inv) => inv.itemId == itemId);
  }

  // Helper untuk get item quantity
  int getItemQuantity(String itemId) {
    final item = inventory.firstWhere(
      (inv) => inv.itemId == itemId,
      orElse: () => InventoryItem(itemId: 'none', quantity: 0),
    );
    return item.quantity;
  }
}
