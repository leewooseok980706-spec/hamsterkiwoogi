import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/hamster_repository.dart';
import '../domain/hamster_model.dart';
import '../domain/hamster_engine.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../../core/constants/game_constants.dart';

final hamsterRepositoryProvider = Provider((ref) => HamsterRepository());

final hamsterProvider = AsyncNotifierProvider<HamsterNotifier, HamsterModel?>(
  HamsterNotifier.new,
);

class HamsterNotifier extends AsyncNotifier<HamsterModel?> {
  Timer? _syncTimer;
  Timer? _decayTimer;

  @override
  Future<HamsterModel?> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return null;

    final repo = ref.read(hamsterRepositoryProvider);
    final hamster = await repo.fetchHamster(user.id);

    if (hamster != null) _startTimers();

    ref.onDispose(() {
      _syncTimer?.cancel();
      _decayTimer?.cancel();
    });

    return hamster;
  }

  void _startTimers() {
    // 1분마다 스탯 감소 반영
    _decayTimer?.cancel();
    _decayTimer = Timer.periodic(const Duration(minutes: 1), (_) => _applyDecay());

    // 30분마다 Supabase 동기화
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(
      Duration(minutes: GameConstants.syncIntervalMinutes),
      (_) => syncToCloud(),
    );
  }

  void _applyDecay() {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(HamsterEngine.applyTimeDecay(current));
  }

  Future<void> performAction(HamsterAction action) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = HamsterEngine.applyAction(current, action);
    state = AsyncData(updated);

    // 즉시 로컬 저장
    await ref.read(hamsterRepositoryProvider).saveLocally(updated);
  }

  Future<void> createHamster(String name) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final repo = ref.read(hamsterRepositoryProvider);
    final hamster = await repo.createHamster(user.id, name);
    state = AsyncData(hamster);
    _startTimers();
  }

  Future<void> syncToCloud() async {
    final current = state.valueOrNull;
    if (current == null) return;
    await ref.read(hamsterRepositoryProvider).syncToCloud(current);
  }
}
