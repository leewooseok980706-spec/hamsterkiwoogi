import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(authRepositoryProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFD9B0), Color(0xFFFFF8F0)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // 로고 / 타이틀
                const Text(
                  '🐹',
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 16),
                const Text(
                  '햄스터 키우기',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3728),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '귀여운 친구를 만나세요',
                  style: TextStyle(fontSize: 16, color: Color(0xFF9B7B6A)),
                ),
                const Spacer(),
                // Google 로그인
                _SocialLoginButton(
                  label: 'Google로 계속하기',
                  icon: '🌐',
                  onTap: () => repo.signInWithGoogle(),
                ),
                const SizedBox(height: 12),
                // Apple 로그인
                _SocialLoginButton(
                  label: 'Apple로 계속하기',
                  icon: '🍎',
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onTap: () => repo.signInWithApple(),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String label;
  final String icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _SocialLoginButton({
    required this.label,
    required this.icon,
    this.backgroundColor = Colors.white,
    this.textColor = const Color(0xFF4A3728),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
