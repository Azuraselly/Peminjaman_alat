import 'package:flutter/material.dart';
import 'package:inventory_alat/admin/screen/beranda.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      home: const BerandaPage(),
    );
  }
}