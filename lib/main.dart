import 'package:flutter/material.dart';
import 'package:inventory_alat/admin/screen/beranda.dart';
import 'package:inventory_alat/peminjam/component/main_navigation.dart';
import 'package:inventory_alat/peminjam/models/data.dart';
import 'package:inventory_alat/peminjam/screen/beranda.dart';
import 'package:inventory_alat/peminjam/screen/peminjam.dart';
import 'package:inventory_alat/petugas/screen/managemen_petugas_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      home: MainNavigationPeminjam(),
    );
  }
}