/// 햄스터 스탯 관련 게임 상수
class GameConstants {
  // 시간당 스탯 감소량
  static const double hungerDecayPerHour = 5.0;
  static const double healthDecayPerHour = 2.0;
  static const double happinessDecayPerHour = 3.0;

  // 인터랙션별 스탯 증가량
  static const int feedHunger = 30;
  static const int feedHealth = 10;
  static const int playHappiness = 25;
  static const int playHealth = -5;
  static const int petHappiness = 15;
  static const int greetHappiness = 10;

  // 애니메이션 상태 임계값
  static const int happyThreshold = 60;
  static const int hungryThreshold = 30;
  static const int sadThreshold = 30;
  static const int sickThreshold = 20;

  // 동기화 주기 (분)
  static const int syncIntervalMinutes = 30;

  // 말풍선 표시 시간 (초)
  static const int speechBubbleDuration = 2;

  // 채팅 키워드
  static const Map<List<String>, String> chatKeywords = {
    // key를 List로 쓸 수 없으므로 HamsterChatMatcher에서 관리
  };
}

/// 햄스터 인터랙션 타입
enum HamsterAction { feed, play, pet, greet, unknown }

/// 채팅 키워드 매처
class HamsterChatMatcher {
  static HamsterAction match(String input) {
    final text = input.trim().toLowerCase();
    if (_contains(text, ['밥', '먹이', '배고파', '먹자', '냠'])) return HamsterAction.feed;
    if (_contains(text, ['놀자', '심심해', '놀아줘', '같이'])) return HamsterAction.play;
    if (_contains(text, ['쓰다듬', '귀여워', '예뻐', '만져'])) return HamsterAction.pet;
    if (_contains(text, ['안녕', '왔어', '왔다', '하이', '헬로'])) return HamsterAction.greet;
    return HamsterAction.unknown;
  }

  static bool _contains(String text, List<String> keywords) =>
      keywords.any((k) => text.contains(k));
}

/// 인터랙션별 햄스터 응답 메시지
class HamsterResponse {
  static String getMessage(HamsterAction action) {
    switch (action) {
      case HamsterAction.feed:
        return '냠냠! 맛있어요~ 🍎';
      case HamsterAction.play:
        return '같이 놀아요! 🎉';
      case HamsterAction.pet:
        return '기분 좋아요~ 😊';
      case HamsterAction.greet:
        return '기다렸어요! 💕';
      case HamsterAction.unknown:
        final responses = ['...🤔', '응?', '뭐라고요?', '(고개 갸웃)'];
        return responses[DateTime.now().millisecond % responses.length];
    }
  }
}
