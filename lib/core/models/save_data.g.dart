// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaveDataAdapter extends TypeAdapter<SaveData> {
  @override
  final int typeId = 0;

  @override
  SaveData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveData(
      slotNumber: fields[0] as int,
      savedAt: fields[1] as DateTime,
      dungeonName: fields[2] as String,
      currentFloor: fields[3] as int,
      maxFloor: fields[4] as int,
      playerLevel: fields[5] as int,
      playerHp: fields[6] as int,
      playerMaxHp: fields[7] as int,
      playerXp: fields[8] as int,
      playerMaxXp: fields[9] as int,
      playerMp: fields[10] as int,
      playerMaxMp: fields[11] as int,
      playerAttack: fields[12] as int,
      playerSkill: fields[13] as int,
      playerDefense: fields[14] as int,
      gold: fields[15] as int,
      inventory: (fields[16] as List).cast<SaveInventoryItem>(),
      purchasedBoostItemIds: (fields[17] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SaveData obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.slotNumber)
      ..writeByte(1)
      ..write(obj.savedAt)
      ..writeByte(2)
      ..write(obj.dungeonName)
      ..writeByte(3)
      ..write(obj.currentFloor)
      ..writeByte(4)
      ..write(obj.maxFloor)
      ..writeByte(5)
      ..write(obj.playerLevel)
      ..writeByte(6)
      ..write(obj.playerHp)
      ..writeByte(7)
      ..write(obj.playerMaxHp)
      ..writeByte(8)
      ..write(obj.playerXp)
      ..writeByte(9)
      ..write(obj.playerMaxXp)
      ..writeByte(10)
      ..write(obj.playerMp)
      ..writeByte(11)
      ..write(obj.playerMaxMp)
      ..writeByte(12)
      ..write(obj.playerAttack)
      ..writeByte(13)
      ..write(obj.playerSkill)
      ..writeByte(14)
      ..write(obj.playerDefense)
      ..writeByte(15)
      ..write(obj.gold)
      ..writeByte(16)
      ..write(obj.inventory)
      ..writeByte(17)
      ..write(obj.purchasedBoostItemIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SaveInventoryItemAdapter extends TypeAdapter<SaveInventoryItem> {
  @override
  final int typeId = 1;

  @override
  SaveInventoryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveInventoryItem(
      itemId: fields[0] as String,
      quantity: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SaveInventoryItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveInventoryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
