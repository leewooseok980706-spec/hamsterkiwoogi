// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hamster_model.dart';

class HamsterModelAdapter extends TypeAdapter<HamsterModel> {
  @override
  final int typeId = 0;

  @override
  HamsterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HamsterModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      name: fields[2] as String,
      hunger: fields[3] as double,
      happiness: fields[4] as double,
      health: fields[5] as double,
      level: fields[6] as int,
      lastFedAt: fields[7] as DateTime,
      lastSyncedAt: fields[8] as DateTime,
      hamsterType: fields[9] as String? ?? 'golden',
    );
  }

  @override
  void write(BinaryWriter writer, HamsterModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.hunger)
      ..writeByte(4)
      ..write(obj.happiness)
      ..writeByte(5)
      ..write(obj.health)
      ..writeByte(6)
      ..write(obj.level)
      ..writeByte(7)
      ..write(obj.lastFedAt)
      ..writeByte(8)
      ..write(obj.lastSyncedAt)
      ..writeByte(9)
      ..write(obj.hamsterType);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HamsterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
