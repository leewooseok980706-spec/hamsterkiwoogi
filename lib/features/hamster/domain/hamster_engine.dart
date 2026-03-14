import 'dart:math';
import '../../../core/constants/game_constants.dart';
import 'hamster_model.dart';

/// 시간 기반 스탯 계산 엔진
class HamsterEngine {
  /// 오프라인 경과 시간만큼 스탯 감소 적용
  static HamsterModel applyTimeDecay(HamsterModel hamster) {
    final now = DateTime.now();
    final elapsed = now.difference(hamster.lastFedAt);
    final hours = elapsed.inMinutes / 60.0;

    final newHunger = max(0.0, hamster.hunger - GameConstants.hungerDecayPerHour * hours);
    final newHealth = max(0.0, hamster.health - GameConstants.healthDecayPerHour * hours);
    final newHappiness = max(0.0, hamster.happiness - GameConstants.happinessDecayPerHour * hours);

    return hamster.copyWith(
      hunger: newHunger,
      health: newHealth,
      happiness: newHappiness,
    );
  }

  /// 인터랙션 적용
  static HamsterModel applyAction(HamsterModel hamster, HamsterAction action) {
    double hunger = hamster.hunger;
    double happiness = hamster.happiness;
    double health = hamster.health;

    switch (action) {
      case HamsterAction.feed:
        hunger = min(100, hunger + GameConstants.feedHunger);
        health = min(100, health + GameConstants.feedHealth);
        break;
      case HamsterAction.play:
        happiness = min(100, happiness + GameConstants.playHappiness);
        health = max(0, health + GameConstants.playHealth);
        break;
      case HamsterAction.pet:
        happiness = min(100, happiness + GameConstants.petHappiness);
        break;
      case HamsterAction.greet:
        happiness = min(100, happiness + GameConstants.greetHappiness);
        break;
      case HamsterAction.unknown:
        break;
    }

    return hamster.copyWith(
      hunger: hunger,
      happiness: happiness,
      health: health,
      lastFedAt: action == HamsterAction.feed ? DateTime.now() : hamster.lastFedAt,
    );
  }

  /// 현재 상태에 따른 애니메이션 상태 결정
  static HamsterAnimationState determineAnimation(HamsterModel hamster) {
    if (hamster.health < GameConstants.sickThreshold) return HamsterAnimationState.sick;
    if (hamster.hunger < GameConstants.hungryThreshold) return HamsterAnimationState.hungry;
    if (hamster.happiness < GameConstants.sadThreshold) return HamsterAnimationState.sad;
    if (hamster.hunger > GameConstants.happyThreshold &&
        hamster.happiness > GameConstants.happyThreshold) {
      return HamsterAnimationState.happy;
    }
    return HamsterAnimationState.normal;
  }
}

/// Rive 애니메이션 상태
enum HamsterAnimationState { happy, normal, hungry, sad, sick }

extension HamsterAnimationStateExt on HamsterAnimationState {
  String get riveName {
    switch (this) {
      case HamsterAnimationState.happy:
        return 'happy_idle';
      case HamsterAnimationState.normal:
        return 'normal_idle';
      case HamsterAnimationState.hungry:
        return 'hungry_idle';
      case HamsterAnimationState.sad:
        return 'sad_idle';
      case HamsterAnimationState.sick:
        return 'sick_idle';
    }
  }

  String get speechBubble {
    switch (this) {
      case HamsterAnimationState.happy:
        return '😊 기분 좋아요!';
      case HamsterAnimationState.normal:
        return '💭 ...';
      case HamsterAnimationState.hungry:
        return '🍎 배고파요!';
      case HamsterAnimationState.sad:
        return '😢 심심해요...';
      case HamsterAnimationState.sick:
        return '🤒 아파요...';
    }
  }
}
