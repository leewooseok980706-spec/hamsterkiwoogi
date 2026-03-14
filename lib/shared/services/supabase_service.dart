import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // TODO: Supabase 프로젝트 생성 후 아래 값을 교체하세요
  static const String _supabaseUrl = 'https://yyrqbszuqnjnhltlhbnh.supabase.co';
  static const String _supabaseAnonKey = 'sb_publishable_gA1SzWgI11oZ43bjpecEtA_FnzEE0gS';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
  static User? get currentUser => client.auth.currentUser;
  static String? get currentUserId => currentUser?.id;
}
