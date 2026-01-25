import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/petugas/component/Tab_home.dart';
import 'package:inventory_alat/petugas/component/tab_monitoring.dart';
import 'package:inventory_alat/petugas/component/tab_laporan.dart';

class PetugasMainScreen extends StatefulWidget {
  const PetugasMainScreen({super.key});

  @override
  State<PetugasMainScreen> createState() => _PetugasMainScreenState();
}

class _PetugasMainScreenState extends State<PetugasMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeApprovalTab(),
    const TabMonitoring(),
    const TabLaporan(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF1A314D),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Pantau'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Laporan'),
        ],
      ),
    );
  }
}