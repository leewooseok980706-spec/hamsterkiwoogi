import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/hamster_engine.dart';
import '../../../core/constants/game_constants.dart';
import 'hamster_provider.dart';
import 'stat_bar_widget.dart';
import 'chat_input_widget.dart';
import 'speech_bubble_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _currentBubbleMessage;
  Key _bubbleKey = UniqueKey();

  void _onChatSend(HamsterAction action, String message) {
    // 스탯 업데이트
    ref.read(hamsterProvider.notifier).performAction(action);

    // 말풍선 표시
    final response = HamsterResponse.getMessage(action);

    setState(() {
      _currentBubbleMessage = response;
      _bubbleKey = UniqueKey();
    });
  }

  void _onBubbleDismissed() {
    setState(() => _currentBubbleMessage = null);
  }

  @override
  Widget build(BuildContext context) {
    final hamsterAsync = ref.watch(hamsterProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '햄스터 키우기',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: hamsterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (hamster) {
          if (hamster == null) return const Center(child: Text('햄스터가 없어요'));

          final animState = HamsterEngine.determineAnimation(hamster);

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. 배경 (풀스크린)
              _HamsterBackground(animState: animState),

              // 2. 햄스터 애니메이션 (중앙, 풀스크린)
              _HamsterView(
                animState: animState,
                bubbleMessage: _currentBubbleMessage,
                bubbleKey: _bubbleKey,
                onBubbleDismissed: _onBubbleDismissed,
              ),

              // 3. 상단: 스탯 바 오버레이
              Positioned(
                top: kToolbarHeight + MediaQuery.of(context).padding.top + 8,
                left: 0,
                right: 0,
                child: StatBarWidget(
                  hunger: hamster.hunger,
                  happiness: hamster.happiness,
                  health: hamster.health,
                ),
              ),

              // 4. 하단: 채팅 입력창 오버레이
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
                child: ChatInputWidget(onSend: _onChatSend),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HamsterBackground extends StatelessWidget {
  final HamsterAnimationState animState;

  const _HamsterBackground({required this.animState});

  @override
  Widget build(BuildContext context) {
    // 상태별 배경 그라데이션
    final colors = switch (animState) {
      HamsterAnimationState.happy => [const Color(0xFFFFD9B0), const Color(0xFFFFB347)],
      HamsterAnimationState.sad => [const Color(0xFFB0C4DE), const Color(0xFF708090)],
      HamsterAnimationState.hungry => [const Color(0xFFFFE4B5), const Color(0xFFDEB887)],
      HamsterAnimationState.sick => [const Color(0xFFE0E0E0), const Color(0xFFA0A0A0)],
      HamsterAnimationState.normal => [const Color(0xFFE8F5E9), const Color(0xFF81C784)],
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
    );
  }
}

class _HamsterView extends StatelessWidget {
  final HamsterAnimationState animState;
  final String? bubbleMessage;
  final Key bubbleKey;
  final VoidCallback onBubbleDismissed;

  const _HamsterView({
    required this.animState,
    required this.bubbleMessage,
    required this.bubbleKey,
    required this.onBubbleDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 말풍선 (머리 위)
          if (bubbleMessage != null)
            SpeechBubbleWidget(
              key: bubbleKey,
              message: bubbleMessage!,
              onDismissed: onBubbleDismissed,
            ),
          const SizedBox(height: 8),

          // 햄스터 (Rive 자리 — 현재는 이모지로 플레이스홀더)
          Text(
            _getHamsterEmoji(animState),
            style: const TextStyle(fontSize: 120),
          ),
        ],
      ),
    );
  }

  String _getHamsterEmoji(HamsterAnimationState state) {
    return switch (state) {
      HamsterAnimationState.happy => '🐹',
      HamsterAnimationState.normal => '🐹',
      HamsterAnimationState.hungry => '🐹',
      HamsterAnimationState.sad => '🐹',
      HamsterAnimationState.sick => '🐹',
    };
    // TODO: Rive 애니메이션 파일 준비 후 RiveAnimation.asset()으로 교체
  }
}
