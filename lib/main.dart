import 'package:flutter/material.dart';
import 'package:inventory_alat/admin/screen/beranda.dart';
import 'package:inventory_alat/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inventory_alat/auth/login_page.dart';
import 'package:inventory_alat/admin/screen/admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://bzfhjtcfsqxgvxdwfvte.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ6ZmhqdGNmc3F4Z3Z4ZHdmdnRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc5MDcwODgsImV4cCI6MjA4MzQ4MzA4OH0.d29OkD0GHhPpx6zHTM9NaKwmCtwhfrrW8t0g42bAGDE',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduGarage',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
     initialRoute: '/', 
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
      }
    );
  }
}