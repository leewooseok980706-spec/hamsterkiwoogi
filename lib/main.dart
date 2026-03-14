import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/services/supabase_service.dart';
import 'shared/services/hive_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 서비스 초기화
  await SupabaseService.initialize();
  await HiveService.initialize();

  runApp(
    const ProviderScope(
      child: HamsterApp(),
    ),
  );
}
