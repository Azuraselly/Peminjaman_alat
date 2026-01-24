import 'package:flutter/material.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/stat_card.dart';
import 'package:inventory_alat/admin/component/activity_card.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/screen/admin.dart';
import 'package:inventory_alat/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  // Variabel untuk melacak halaman mana yang aktif
  int _currentIndex = 0;

  // 2. Fungsi untuk menampilkan konten berdasarkan index
  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildMainContent(); // Halaman Beranda
      case 1:
        return const AdminPage();
      case 2:
        return const Center(
          child: Text("Halaman Transaksi", style: TextStyle(fontSize: 20)),
        );
      case 3:
        return const Center(
          child: Text("Halaman Riwayat", style: TextStyle(fontSize: 20)),
        );
      default:
        return _buildMainContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      // NAVBAR TETAP DI BAWAH (FIXED)
      bottomNavigationBar: CustomNavbar(
        selectedIndex: _currentIndex,
        onItemTapped: (index) {
          setState(() {
            _currentIndex = index; // Ganti halaman saat diklik
          });
        },
      ),
      body: Column(
        children: [
          const CustomHeader(), // Header tetap di atas (Fixed)
          Expanded(
            child: _buildBody(), // Isi konten berubah sesuai tombol navbar
          ),
        ],
      ),
    );
  }

  // 3. Pindahkan konten Beranda ke fungsi terpisah agar rapi
  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Row(
            children: [
              Icon(Icons.grid_view_rounded, color: AppColors.selly, size: 28),
              const SizedBox(width: 10),
              Text(
                "Sistem",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            children: const [
              StatCard(
                title: "USER",
                value: "110",
                icon: Icons.people_alt_rounded,
                color: Color(0xFF4C73B3),
              ),
              StatCard(
                title: "ALAT",
                value: "95",
                icon: Icons.build_rounded,
                color: Color(0xFF8B6DF0),
              ),
              StatCard(
                title: "TRANSAKSI",
                value: "360",
                icon: Icons.swap_horiz_rounded,
                color: Colors.orange,
              ),
              StatCard(
                title: "KATEGORI",
                value: "9",
                icon: Icons.local_offer,
                color: Color(0xFF27AE60),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const ActivityCard(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
