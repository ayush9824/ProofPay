import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get supabaseUrl {
    String url = const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    
    if (url.isEmpty) {
      url = dotenv.env['SUPABASE_URL'] ?? '';
    }
    
    if (url.isEmpty && !kIsWeb) {
      url = Platform.environment['SUPABASE_URL'] ?? '';
    }
    
    return url;
  }
      
  static String get supabaseAnonKey {
    String key = const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
    
    if (key.isEmpty) {
      key = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
    }
    
    if (key.isEmpty && !kIsWeb) {
      key = Platform.environment['SUPABASE_ANON_KEY'] ?? '';
    }
    
    return key;
  }
      
  static String get geminiApiKey {
    String key = const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
    
    if (key.isEmpty) {
      key = dotenv.env['GEMINI_API_KEY'] ?? '';
    }
    
    if (key.isEmpty && !kIsWeb) {
      key = Platform.environment['GEMINI_API_KEY'] ?? '';
    }
    
    return key;
  }

  static Future<void> init() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      print("Warning: .env file not found or could not be loaded.");
    }
  }
}
