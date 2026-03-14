import 'package:hive_flutter/hive_flutter.dart';
import '../../features/hamster/domain/hamster_model.dart';

class HiveService {
  static const String hamsterBox = 'hamster_box';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HamsterModelAdapter());
    await Hive.openBox<HamsterModel>(hamsterBox);
  }

  static Box<HamsterModel> get hamsters => Hive.box<HamsterModel>(hamsterBox);

  static HamsterModel? getCachedHamster() {
    final box = hamsters;
    if (box.isEmpty) return null;
    return box.getAt(0);
  }

  static Future<void> saveHamster(HamsterModel hamster) async {
    final box = hamsters;
    if (box.isEmpty) {
      await box.add(hamster);
    } else {
      await box.putAt(0, hamster);
    }
  }

  static Future<void> clearHamster() async {
    await hamsters.clear();
  }
}
