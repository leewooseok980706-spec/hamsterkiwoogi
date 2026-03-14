import 'package:flutter/material.dart';

enum HamsterType {
  golden,   // 골든 햄스터
  dwarf,    // 드워프 햄스터
  white,    // 흰 햄스터
  gray,     // 회색 햄스터
  roborovski, // 로보로프스키
}

extension HamsterTypeExt on HamsterType {
  String get id => name;

  String get displayName {
    switch (this) {
      case HamsterType.golden:     return '골든 햄스터';
      case HamsterType.dwarf:      return '드워프 햄스터';
      case HamsterType.white:      return '흰 햄스터';
      case HamsterType.gray:       return '회색 햄스터';
      case HamsterType.roborovski: return '로보로프스키';
    }
  }

  String get emoji {
    switch (this) {
      case HamsterType.golden:     return '🐹';
      case HamsterType.dwarf:      return '🐭';
      case HamsterType.white:      return '🤍';
      case HamsterType.gray:       return '🩶';
      case HamsterType.roborovski: return '⭐';
    }
  }

  String get description {
    switch (this) {
      case HamsterType.golden:     return '통통하고 귀여운\n가장 대표적인 햄스터';
      case HamsterType.dwarf:      return '작고 빠른\n애교쟁이 햄스터';
      case HamsterType.white:      return '새하얀 털을 가진\n청순한 햄스터';
      case HamsterType.gray:       return '차분하고 얌전한\n지적인 햄스터';
      case HamsterType.roborovski: return '세상에서 제일 작은\n엄청 빠른 햄스터';
    }
  }

  // 햄스터 몸통 색상
  Color get bodyColor {
    switch (this) {
      case HamsterType.golden:     return const Color(0xFFD4A017);
      case HamsterType.dwarf:      return const Color(0xFFC8A882);
      case HamsterType.white:      return const Color(0xFFF5F0EB);
      case HamsterType.gray:       return const Color(0xFFAAAAAA);
      case HamsterType.roborovski: return const Color(0xFFE8C99A);
    }
  }

  // 햄스터 배 색상
  Color get bellyColor {
    switch (this) {
      case HamsterType.golden:     return const Color(0xFFF5DEB3);
      case HamsterType.dwarf:      return const Color(0xFFEDE0D0);
      case HamsterType.white:      return const Color(0xFFFFFFFF);
      case HamsterType.gray:       return const Color(0xFFD0D0D0);
      case HamsterType.roborovski: return const Color(0xFFFFF8F0);
    }
  }

  // 배경 그라데이션 색상
  List<Color> get backgroundColors {
    switch (this) {
      case HamsterType.golden:     return [const Color(0xFFFFE57A), const Color(0xFFFFB347)];
      case HamsterType.dwarf:      return [const Color(0xFFFFD9B0), const Color(0xFFE8A87C)];
      case HamsterType.white:      return [const Color(0xFFE8F4FD), const Color(0xFFB8D4E8)];
      case HamsterType.gray:       return [const Color(0xFFE0E0E0), const Color(0xFFAAAAAA)];
      case HamsterType.roborovski: return [const Color(0xFFFFF3CD), const Color(0xFFFFD700)];
    }
  }

  static HamsterType fromId(String id) {
    return HamsterType.values.firstWhere(
      (t) => t.id == id,
      orElse: () => HamsterType.golden,
    );
  }
}
