import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/peminjam/screen/beranda.dart';
import 'package:inventory_alat/peminjam/screen/checkout.dart';
import 'package:inventory_alat/peminjam/screen/profil.dart';
import 'package:inventory_alat/peminjam/screen/riwayat.dart';
import 'package:inventory_alat/peminjam/models/data.dart';

class Peminjam extends StatefulWidget {
  const Peminjam({super.key});

  @override
  State<Peminjam> createState() => _PeminjamState();
}

class _PeminjamState extends State<Peminjam> {
  int _currentIndex = 0;

  // Data Global (State)
  List<Alat> keranjang = [];
  List<Map<String, dynamic>> riwayat = [
    {"nama": "Scanner OBD II", "tgl": "22 Jan 2026", "status": "Kembali"},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      BerandaContent(onAdd: (alat) => setState(() => keranjang.add(alat)), daftarAlat: [], onAddKeranjang: (Alat alat) {  },),
      KeranjangPage(
        items: keranjang, 
        onRemove: (index) => setState(() => keranjang.removeAt(index)),
        onCheckout: () {
          setState(() {
            for (var item in keranjang) {
              riwayat.insert(0, {"nama": item.nama, "tgl": "25 Jan 2026", "status": "Proses"});
            }
            keranjang.clear();
            _currentIndex = 2; // Pindah ke tab riwayat
          });
        }, keranjangItems: [], onRemoveKeranjang: (index) {  },
      ),
      RiwayatPage(dataRiwayat: riwayat),
      const ProfilPeminjamPage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A314D),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_max_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Keranjang"),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: "Profil"),
        ],
      ),
    );
  }
}