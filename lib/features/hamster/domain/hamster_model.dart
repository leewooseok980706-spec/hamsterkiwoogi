import 'package:hive_flutter/hive_flutter.dart';

part 'hamster_model.g.dart';

@HiveType(typeId: 0)
class HamsterModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  String name;

  @HiveField(3)
  double hunger;

  @HiveField(4)
  double happiness;

  @HiveField(5)
  double health;

  @HiveField(6)
  int level;

  @HiveField(7)
  DateTime lastFedAt;

  @HiveField(8)
  DateTime lastSyncedAt;

  HamsterModel({
    required this.id,
    required this.userId,
    required this.name,
    this.hunger = 80,
    this.happiness = 80,
    this.health = 100,
    this.level = 1,
    required this.lastFedAt,
    required this.lastSyncedAt,
  });

  factory HamsterModel.fromJson(Map<String, dynamic> json) => HamsterModel(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        name: json['name'] as String,
        hunger: (json['hunger'] as num).toDouble(),
        happiness: (json['happiness'] as num).toDouble(),
        health: (json['health'] as num).toDouble(),
        level: json['level'] as int,
        lastFedAt: DateTime.parse(json['last_fed_at'] as String),
        lastSyncedAt: DateTime.parse(json['last_synced_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'hunger': hunger.round(),
        'happiness': happiness.round(),
        'health': health.round(),
        'level': level,
        'last_fed_at': lastFedAt.toIso8601String(),
        'last_synced_at': lastSyncedAt.toIso8601String(),
      };

  HamsterModel copyWith({
    String? name,
    double? hunger,
    double? happiness,
    double? health,
    int? level,
    DateTime? lastFedAt,
    DateTime? lastSyncedAt,
  }) =>
      HamsterModel(
        id: id,
        userId: userId,
        name: name ?? this.name,
        hunger: hunger ?? this.hunger,
        happiness: happiness ?? this.happiness,
        health: health ?? this.health,
        level: level ?? this.level,
        lastFedAt: lastFedAt ?? this.lastFedAt,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      );
}
