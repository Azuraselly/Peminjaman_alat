import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/petugas/component/Tab_home.dart';
import 'package:inventory_alat/petugas/component/tab_laporan.dart';
import 'package:inventory_alat/petugas/component/tab_monitoring.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePagePetugas extends StatefulWidget {
  const HomePagePetugas({super.key});

  @override
  _HomePagePetugasState createState() => _HomePagePetugasState();
}

class _HomePagePetugasState extends State<HomePagePetugas> {
  String _userName = "Petugas";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final response = await Supabase.instance.client
          .from('users')
          .select('username')
          .eq('id_user', user.id)
          .single();
      if (mounted) {
        setState(() {
          _userName = response['username'] ?? "Petugas";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      TabHomePetugas(userName: _userName),
      TabMonitoring(userName: _userName),
      TabLaporan(userName: _userName),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF1A314D),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold),
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