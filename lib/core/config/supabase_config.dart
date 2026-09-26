import 'package:supabase_flutter/supabase_flutter.dart';
import 'env_config.dart';

class SupabaseConfig {
  static Future<void> init() async {
    final url = EnvConfig.supabaseUrl;
    final anonKey = EnvConfig.supabaseAnonKey;
    
    print('SUPABASE URL EXISTS: ${url.isNotEmpty}');
    if (url.isNotEmpty) {
      final safeUrl = url.length > 8 ? '${url.substring(0, 8)}...' : url;
      print('SUPABASE URL (safe): $safeUrl');
    } else {
      print('SUPABASE URL: (empty)');
    }
    print('SUPABASE URL STARTS WITH HTTPS: ${url.startsWith('https://')}');
    print('SUPABASE URL HAS HOST: ${Uri.tryParse(url)?.host.isNotEmpty == true}');
    print('SUPABASE ANON KEY EXISTS: ${anonKey.isNotEmpty}');
    print('SUPABASE URL = $url');
    
    if (url.isEmpty || anonKey.isEmpty) {
       throw ArgumentError('Supabase URL and Anon Key are empty! Please ensure you have created a .env file with SUPABASE_URL and SUPABASE_ANON_KEY populated, or pass them via --dart-define.');
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey, // ignore: deprecated_member_use
    );
    print('SUPABASE INITIALIZED = true');
  }

  static SupabaseClient get client => Supabase.instance.client;
}
