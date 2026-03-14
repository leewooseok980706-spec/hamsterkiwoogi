import '../../../shared/services/supabase_service.dart';
import '../../../shared/services/hive_service.dart';
import '../domain/hamster_model.dart';
import '../domain/hamster_engine.dart';

class HamsterRepository {
  final _client = SupabaseService.client;

  /// 햄스터 로드: Supabase → 없으면 null 반환
  Future<HamsterModel?> fetchHamster(String userId) async {
    // 로컬 캐시 우선
    final cached = HiveService.getCachedHamster();
    if (cached != null) {
      // 오프라인 경과 시간 적용
      return HamsterEngine.applyTimeDecay(cached);
    }

    // Supabase에서 로드
    final response = await _client
        .from('hamsters')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;

    final hamster = HamsterModel.fromJson(response);
    final decayed = HamsterEngine.applyTimeDecay(hamster);
    await HiveService.saveHamster(decayed);
    return decayed;
  }

  /// 햄스터 생성 (첫 실행)
  Future<HamsterModel> createHamster(String userId, String name) async {
    final now = DateTime.now();
    final response = await _client
        .from('hamsters')
        .insert({
          'user_id': userId,
          'name': name,
          'hunger': 80,
          'happiness': 80,
          'health': 100,
          'level': 1,
          'last_fed_at': now.toIso8601String(),
          'last_synced_at': now.toIso8601String(),
        })
        .select()
        .single();

    final hamster = HamsterModel.fromJson(response);
    await HiveService.saveHamster(hamster);
    return hamster;
  }

  /// 로컬 저장 (즉시 반응성)
  Future<void> saveLocally(HamsterModel hamster) async {
    await HiveService.saveHamster(hamster);
  }

  /// Supabase 동기화
  Future<void> syncToCloud(HamsterModel hamster) async {
    final updated = hamster.copyWith(lastSyncedAt: DateTime.now());
    await _client
        .from('hamsters')
        .upsert(updated.toJson())
        .eq('id', hamster.id);
    await HiveService.saveHamster(updated);
  }

  Future<void> clearLocal() async {
    await HiveService.clearHamster();
  }
}
