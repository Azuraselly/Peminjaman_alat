import 'package:flutter/material.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/stat_card.dart';
import 'package:inventory_alat/admin/component/activity_card.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/screen/admin.dart';
import 'package:inventory_alat/admin/screen/admin/transaksi/transaksi.dart';
import 'package:inventory_alat/admin/screen/log_aktivitas.dart';
import 'package:inventory_alat/service/peminjaman_service.dart'; // Import service
import 'package:inventory_alat/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int _currentIndex = 0;
  int countToday = 0;
  final PeminjamanService _peminjamanService = PeminjamanService();

  // Fungsi untuk menentukan halaman mana yang tampil berdasarkan index navbar
  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildMainContent();
      case 1:
        return const AdminPage();
      case 2:
        return const Transaksi();
      case 3:
        return const RiwayatPage();
      default:
        return _buildMainContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: _currentIndex,
        onItemTapped: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: Column(
        children: [
          const CustomHeader(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {}); // Memicu rebuild FutureBuilder saat ditarik
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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

            // FUTURE BUILDER UNTUK DATA RIIL
            FutureBuilder<Map<String, int>>(
              future: _peminjamanService.getDashboardStats(),
              builder: (context, snapshot) {
                // Default data saat loading atau error
                final stats =
                    snapshot.data ??
                    {'users': 0, 'alat': 0, 'transaksi': 0, 'kategori': 0};
                final bool isLoading =
                    snapshot.connectionState == ConnectionState.waiting;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  children: [
                    StatCard(
                      title: "USER",
                      value: isLoading ? "..." : stats['users'].toString(),
                      icon: Icons.people_alt_rounded,
                      color: const Color(0xFF4C73B3),
                    ),
                    StatCard(
                      title: "ALAT",
                      value: isLoading ? "..." : stats['alat'].toString(),
                      icon: Icons.build_rounded,
                      color: const Color(0xFF8B6DF0),
                    ),
                    StatCard(
                      title: "TRANSAKSI",
                      value: isLoading ? "..." : stats['transaksi'].toString(),
                      icon: Icons.swap_horiz_rounded,
                      color: Colors.orange,
                    ),
                    StatCard(
                      title: "KATEGORI",
                      value: isLoading ? "..." : stats['kategori'].toString(),
                      icon: Icons.local_offer,
                      color: const Color(0xFF27AE60),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 25),
            ActivityCard(
              totalPeminjamanHariIni: countToday,
              onTapCekLaporan: () {
                // Navigasi ke halaman riwayat atau laporan
                Navigator.pushNamed(context, '/riwayat');
              },
            ), // Menampilkan log_aktifitas
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
