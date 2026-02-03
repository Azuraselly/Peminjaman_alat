import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/peminjam/screen/beranda.dart';
import 'package:inventory_alat/peminjam/screen/checkout.dart';
import 'package:inventory_alat/peminjam/screen/profil.dart';
import 'package:inventory_alat/peminjam/screen/riwayat.dart';
import 'package:inventory_alat/peminjam/models/peminjam_models.dart';

class Peminjam extends StatefulWidget {
  const Peminjam({super.key});

  @override
  State<Peminjam> createState() => _PeminjamState();
}

class _PeminjamState extends State<Peminjam> {
  int _currentIndex = 0;

  // ✅ WAJIB KeranjangItem
  List<KeranjangItem> keranjang = [];

  List<Map<String, dynamic>> riwayat = [
    {"nama": "Scanner OBD II", "tgl": "22 Jan 2026", "status": "Kembali"},
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [

      /// ================= BERANDA =================
      BerandaPeminjam(
        onAddToCart: (Alat alat) {
          setState(() {
            keranjang.add(KeranjangItem(alat: alat));
          });
        },
      ),

      /// ================= KERANJANG =================
      KeranjangPeminjam(
        items: keranjang,

        onRemove: (index) {
          setState(() => keranjang.removeAt(index));
        },

        onUpdateQuantity: (index, qty) {
          setState(() => keranjang[index].jumlah = qty);
        },

        onClearCart: () {
          setState(() => keranjang.clear());
        },
      ),

      /// ================= RIWAYAT =================
      const RiwayatPeminjam(),


      /// ================= PROFIL =================
      const ProfilPeminjam(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A314D),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Keranjang"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
