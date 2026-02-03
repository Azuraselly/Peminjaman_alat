import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
   await Supabase.initialize(
    url: 'https://bzfhjtcfsqxgvxdwfvte.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ6ZmhqdGNmc3F4Z3Z4ZHdmdnRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc5MDcwODgsImV4cCI6MjA4MzQ4MzA4OH0.d29OkD0GHhPpx6zHTM9NaKwmCtwhfrrW8t0g42bAGDE',
  );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}