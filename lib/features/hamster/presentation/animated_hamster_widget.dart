import 'dart:math';
import 'package:flutter/material.dart';
import '../domain/hamster_type.dart';
import '../domain/hamster_engine.dart';

class AnimatedHamsterWidget extends StatefulWidget {
  final HamsterType type;
  final HamsterAnimationState animState;
  final String? actionTrigger; // 'eat', 'play', 'pet', 'talk'

  const AnimatedHamsterWidget({
    super.key,
    required this.type,
    required this.animState,
    this.actionTrigger,
  });

  @override
  State<AnimatedHamsterWidget> createState() => _AnimatedHamsterWidgetState();
}

class _AnimatedHamsterWidgetState extends State<AnimatedHamsterWidget>
    with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _actionController;
  late Animation<double> _bounceAnim;
  late Animation<double> _breatheAnim;
  late Animation<double> _earAnim;
  late Animation<double> _tailAnim;
  late Animation<double> _actionAnim;

  @override
  void initState() {
    super.initState();

    // 숨쉬기 + 바운스 (idle)
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // 액션 (먹기, 놀기 등)
    _actionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _bounceAnim = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );
    _breatheAnim = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );
    _earAnim = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );
    _tailAnim = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );
    _actionAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _actionController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(AnimatedHamsterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.actionTrigger != oldWidget.actionTrigger && widget.actionTrigger != null) {
      _actionController.forward(from: 0);
    }

    // 상태에 따라 idle 속도 변경
    switch (widget.animState) {
      case HamsterAnimationState.happy:
        _idleController.duration = const Duration(milliseconds: 900);
        break;
      case HamsterAnimationState.sick:
        _idleController.duration = const Duration(milliseconds: 3000);
        break;
      default:
        _idleController.duration = const Duration(milliseconds: 1800);
    }
  }

  @override
  void dispose() {
    _idleController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_idleController, _actionController]),
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, -_bounceAnim.value),
          child: Transform.scale(
            scale: _breatheAnim.value + _actionAnim.value * 0.1,
            child: CustomPaint(
              size: const Size(220, 220),
              painter: HamsterPainter(
                type: widget.type,
                animState: widget.animState,
                earAngle: _earAnim.value,
                tailAngle: _tailAnim.value,
                actionProgress: _actionAnim.value,
                actionTrigger: widget.actionTrigger,
              ),
            ),
          ),
        );
      },
    );
  }
}

class HamsterPainter extends CustomPainter {
  final HamsterType type;
  final HamsterAnimationState animState;
  final double earAngle;
  final double tailAngle;
  final double actionProgress;
  final String? actionTrigger;

  HamsterPainter({
    required this.type,
    required this.animState,
    required this.earAngle,
    required this.tailAngle,
    required this.actionProgress,
    this.actionTrigger,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 10;

    _drawShadow(canvas, cx, cy, size);
    _drawBody(canvas, cx, cy);
    _drawBelly(canvas, cx, cy);
    _drawEars(canvas, cx, cy);
    _drawFace(canvas, cx, cy);
    _drawPaws(canvas, cx, cy);
    _drawCheeks(canvas, cx, cy);
    if (actionTrigger == 'eat') _drawFood(canvas, cx, cy);
  }

  void _drawShadow(Canvas canvas, double cx, double cy, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 62), width: 120, height: 20),
      paint,
    );
  }

  void _drawBody(Canvas canvas, double cx, double cy) {
    final paint = Paint()..color = type.bodyColor;
    // 몸통 (둥글둥글)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 20), width: 130, height: 110),
      paint,
    );
    // 머리
    canvas.drawCircle(Offset(cx, cy - 28), 58, paint);
  }

  void _drawBelly(Canvas canvas, double cx, double cy) {
    final paint = Paint()..color = type.bellyColor;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + 28), width: 72, height: 60),
      paint,
    );
  }

  void _drawEars(Canvas canvas, double cx, double cy) {
    final outerPaint = Paint()..color = type.bodyColor;
    final innerPaint = Paint()..color = const Color(0xFFFFB6C1);

    for (final side in [-1, 1]) {
      final ex = cx + side * 44.0;
      final ey = cy - 76.0;

      canvas.save();
      canvas.translate(ex, ey);
      canvas.rotate(earAngle * side);
      canvas.drawCircle(Offset.zero, 20, outerPaint);
      canvas.drawCircle(Offset.zero, 12, innerPaint);
      canvas.restore();
    }
  }

  void _drawFace(Canvas canvas, double cx, double cy) {
    // 눈
    final eyePaint = Paint()..color = const Color(0xFF2C1A0E);
    final eyeShine = Paint()..color = Colors.white;

    final isHappy = animState == HamsterAnimationState.happy;
    final isSad = animState == HamsterAnimationState.sad;
    final isSick = animState == HamsterAnimationState.sick;

    for (final side in [-1, 1]) {
      final ex = cx + side * 18.0;
      final ey = cy - 32.0;

      if (isHappy || actionTrigger == 'pet') {
        // 행복한 눈 (^ ^)
        final eyePath = Path();
        eyePath.moveTo(ex - 9, ey);
        eyePath.quadraticBezierTo(ex, ey - 10, ex + 9, ey);
        canvas.drawPath(eyePath, Paint()
          ..color = const Color(0xFF2C1A0E)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round);
      } else if (isSad) {
        // 슬픈 눈 (눈물)
        canvas.drawCircle(Offset(ex, ey), 6, eyePaint);
        canvas.drawCircle(Offset(ex + 3, ey - 3), 2, eyeShine);
        // 눈물방울
        final tearPath = Path()
          ..moveTo(ex + 4, ey + 6)
          ..quadraticBezierTo(ex + 8, ey + 14, ex + 4, ey + 18);
        canvas.drawPath(tearPath, Paint()
          ..color = Colors.lightBlue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5);
      } else if (isSick) {
        // 아픈 눈 (x x)
        final xPaint = Paint()
          ..color = const Color(0xFF2C1A0E)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(ex - 6, ey - 6), Offset(ex + 6, ey + 6), xPaint);
        canvas.drawLine(Offset(ex + 6, ey - 6), Offset(ex - 6, ey + 6), xPaint);
      } else {
        canvas.drawCircle(Offset(ex, ey), 6, eyePaint);
        canvas.drawCircle(Offset(ex + 2, ey - 2), 2, eyeShine);
      }
    }

    // 코
    final nosePaint = Paint()..color = const Color(0xFFFF9999);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - 18), width: 10, height: 7),
      nosePaint,
    );

    // 입 (상태에 따라)
    final mouthPaint = Paint()
      ..color = const Color(0xFF2C1A0E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    if (isHappy || actionTrigger == 'eat') {
      final p = Path()
        ..moveTo(cx - 10, cy - 10)
        ..quadraticBezierTo(cx, cy - 2, cx + 10, cy - 10);
      canvas.drawPath(p, mouthPaint);
    } else if (isSad || isSick) {
      final p = Path()
        ..moveTo(cx - 10, cy - 6)
        ..quadraticBezierTo(cx, cy - 14, cx + 10, cy - 6);
      canvas.drawPath(p, mouthPaint);
    } else {
      final p = Path()
        ..moveTo(cx - 8, cy - 10)
        ..quadraticBezierTo(cx, cy - 6, cx + 8, cy - 10);
      canvas.drawPath(p, mouthPaint);
    }

    // 수염
    final whiskerPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1.2;
    for (int i = 0; i < 3; i++) {
      final y = cy - 16 + i * 5.0;
      canvas.drawLine(Offset(cx - 36, y), Offset(cx - 14, y - 1), whiskerPaint);
      canvas.drawLine(Offset(cx + 14, y - 1), Offset(cx + 36, y), whiskerPaint);
    }
  }

  void _drawCheeks(Canvas canvas, double cx, double cy) {
    final paint = Paint()..color = const Color(0xFFFFB6C1).withOpacity(0.5);
    canvas.drawCircle(Offset(cx - 30, cy - 18), 14, paint);
    canvas.drawCircle(Offset(cx + 30, cy - 18), 14, paint);

    // 볼 채우기 (먹이 주기 시)
    if (actionTrigger == 'eat') {
      final fillPaint = Paint()..color = const Color(0xFFFFB347).withOpacity(0.6 * actionProgress);
      canvas.drawCircle(Offset(cx - 32, cy - 16), 16 * actionProgress, fillPaint);
      canvas.drawCircle(Offset(cx + 32, cy - 16), 16 * actionProgress, fillPaint);
    }
  }

  void _drawPaws(Canvas canvas, double cx, double cy) {
    final paint = Paint()..color = type.bodyColor;
    final innerPaint = Paint()..color = type.bellyColor;

    // 앞발
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 52, cy + 38), width: 28, height: 20),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 52, cy + 38), width: 28, height: 20),
      paint,
    );
    // 발바닥
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 52, cy + 40), width: 18, height: 12),
      innerPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 52, cy + 40), width: 18, height: 12),
      innerPaint,
    );
  }

  void _drawFood(Canvas canvas, double cx, double cy) {
    if (actionProgress < 0.3) return;
    final opacity = (actionProgress - 0.3) / 0.7;

    // 해바라기씨 이모지 대신 간단한 씨앗 모양
    final seedPaint = Paint()..color = const Color(0xFF8B6914).withOpacity(opacity);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 50, cy - 10), width: 12, height: 18),
      seedPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + 50, cy - 10), width: 12, height: 18),
      seedPaint,
    );
  }

  @override
  bool shouldRepaint(HamsterPainter old) =>
      old.earAngle != earAngle ||
      old.tailAngle != tailAngle ||
      old.actionProgress != actionProgress ||
      old.animState != animState ||
      old.type != type;
}
