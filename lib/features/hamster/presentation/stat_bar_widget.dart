import 'package:flutter/material.dart';

class StatBarWidget extends StatelessWidget {
  final double hunger;
  final double happiness;
  final double health;

  const StatBarWidget({
    super.key,
    required this.hunger,
    required this.happiness,
    required this.health,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatRow(icon: '🍎', label: '배고픔', value: hunger, color: const Color(0xFFFF6B6B)),
          const SizedBox(height: 6),
          _StatRow(icon: '😊', label: '행복도', value: happiness, color: const Color(0xFFFFD93D)),
          const SizedBox(height: 6),
          _StatRow(icon: '💪', label: '체력', value: health, color: const Color(0xFF6BCB77)),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String icon;
  final String label;
  final double value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${value.round()}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
