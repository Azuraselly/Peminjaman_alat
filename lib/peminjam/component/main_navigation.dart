import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/peminjam/models/data.dart';
import 'package:inventory_alat/peminjam/screen/beranda.dart';
import 'package:inventory_alat/peminjam/screen/cari.dart';
import 'package:inventory_alat/peminjam/screen/checkout.dart';
import 'package:inventory_alat/peminjam/screen/profil.dart';
import 'package:inventory_alat/peminjam/screen/riwayat.dart';

class MainNavigationPeminjam extends StatefulWidget {
  const MainNavigationPeminjam({super.key});

  @override
  State<MainNavigationPeminjam> createState() => _MainNavigationPeminjamState();
}

class _MainNavigationPeminjamState extends State<MainNavigationPeminjam> {
  int _currentIndex = 0;

  // Global State untuk data
  List<Alat> daftarAlat = [
    Alat(id: 1, nama: "Kunci Pas", kategori: "Kunci", stok: 10),
    Alat(id: 2, nama: "Obeng Set", kategori: "Kunci", stok: 15),
    Alat(id: 3, nama: "Multimeter", kategori: "Elektrik", stok: 5),
    Alat(id: 4, nama: "Kunci Inggris", kategori: "Kunci", stok: 7),
    Alat(id: 5, nama: "Tang Kombinasi", kategori: "Umum", stok: 12),
    Alat(id: 6, nama: "Bor Tangan", kategori: "Mesin", stok: 3),
  ];

  List<Alat> keranjang = [];
  List<Map<String, dynamic>> riwayat = [
    {"nama": "Scanner OBD II", "tgl": "22 Jan 2026", "status": "Kembali"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Latar belakang abu-abu terang
      // 1. TOMBOL CHECKOUT MELAYANG DI TENGAH
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi ketika tombol bulat tengah diklik
          if (_currentIndex != 1 && keranjang.isNotEmpty) {
            setState(() => _currentIndex = 1); // Pindah ke halaman keranjang
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Ayo selesaikan peminjamanmu!"),
                duration: Duration(seconds: 1),
              ),
            );
          } else if (keranjang.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Keranjangmu masih kosong.")),
            );
          }
        },
        backgroundColor: const Color(0xFF1A314D),
        shape: const CircleBorder(), // Membuatnya bulat sempurna
        elevation: 8, // Sedikit efek bayangan
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.add_shopping_cart_rounded, color: Colors.white),
            if (keranjang.isNotEmpty)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Text(
                    keranjang.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),

      // 2. LOKASI TOMBOL DI TENGAH NAVBAR
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 3. CUSTOM NAVBAR DENGAN LUBANG (NOTCH)
      bottomNavigationBar: BottomAppBar(
        shape:
            const CircularNotchedRectangle(), // Membuat lubang untuk tombol melayang
        notchMargin: 8.0, // Jarak lubang dari tepi
        clipBehavior: Clip.antiAlias, // Memastikan bentuk potongan rapi
        elevation: 8, // Bayangan di navbar
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Sisi Kiri
              _buildNavItem(Icons.home_filled, "Beranda", 0),
              _buildNavItem(
                Icons.shopping_bag_rounded,
                "Pinjam",
                1,
              ), // Mengganti keranjang dengan Pinjam

              const SizedBox(width: 40), // Ruang kosong untuk tombol tengah
              // Sisi Kanan
              _buildNavItem(Icons.history_rounded, "Riwayat", 2),
              _buildNavItem(Icons.person, "Profil", 3),
            ],
          ),
        ),
      ),

      // Konten Halaman
      body: _buildPageContent(),
    );
  }

  // Helper untuk item Navbar
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque, // Agar seluruh area bisa diklik
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5, // Mengatur lebar agar pas
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF1A314D) : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: isActive ? const Color(0xFF1A314D) : Colors.grey[600],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Memilih konten halaman berdasarkan _currentIndex
  Widget _buildPageContent() {
    switch (_currentIndex) {
      case 0:
        return BerandaContent(
          daftarAlat: daftarAlat,
          onAddKeranjang: (alat) => setState(() => keranjang.add(alat)),
          onAdd: (alat) {},
        );
      case 1:
        return CariPage();

      case 2:
        return RiwayatPage(dataRiwayat: riwayat);
      case 3:
        return const ProfilPeminjamPage();
      default:
        return Container();
    }
  }
}
