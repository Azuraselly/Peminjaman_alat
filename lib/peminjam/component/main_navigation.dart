import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/peminjam/models/peminjam_models.dart';
import 'package:inventory_alat/peminjam/screen/beranda.dart';
import 'package:inventory_alat/peminjam/screen/cari.dart';
import 'package:inventory_alat/peminjam/screen/profil.dart';
import 'package:inventory_alat/peminjam/screen/riwayat.dart';

class MainNavigationPeminjam extends StatefulWidget {
  const MainNavigationPeminjam({super.key});

  @override
  State<MainNavigationPeminjam> createState() => _MainNavigationPeminjamState();
}

class _MainNavigationPeminjamState extends State<MainNavigationPeminjam> {
  int _currentIndex = 0;

  // Global State untuk keranjang
  final List<KeranjangItem> _keranjang = [];

  // Add item to cart
  void _addToKeranjang(Alat alat) {
    setState(() {
      // Check if item already in cart
      final existingIndex = _keranjang.indexWhere(
        (item) => item.alat.idAlat == alat.idAlat,
      );

      if (existingIndex >= 0) {
        // Item exists, increase quantity if possible
        if (_keranjang[existingIndex].canIncrease) {
          _keranjang[existingIndex].jumlah++;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${alat.namaAlat} ditambahkan (${_keranjang[existingIndex].jumlah} unit)'),
              duration: const Duration(seconds: 1),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Stok ${alat.namaAlat} tidak mencukupi'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        // Add new item
        _keranjang.add(KeranjangItem(alat: alat, jumlah: 1));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${alat.namaAlat} ditambahkan ke keranjang!'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  // Remove item from cart
  void _removeFromKeranjang(int index) {
    setState(() {
      _keranjang.removeAt(index);
    });
  }

  // Update item quantity
  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0 && newQuantity <= _keranjang[index].maxJumlah) {
        _keranjang[index].jumlah = newQuantity;
      }
    });
  }

  // Clear cart after checkout
  void _clearKeranjang() {
    setState(() {
      _keranjang.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      
      // 1. TOMBOL CHECKOUT MELAYANG DI TENGAH
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_keranjang.isNotEmpty) {
            // Navigate to keranjang page
            setState(() => _currentIndex = 1);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Keranjangmu masih kosong."),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        backgroundColor: const Color(0xFF1A314D),
        shape: const CircleBorder(),
        elevation: 8,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.shopping_cart_rounded, color: Colors.white),
            if (_keranjang.isNotEmpty)
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
                    _keranjang.length.toString(),
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
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Sisi Kiri
              _buildNavItem(Icons.home_filled, "Beranda", 0),
              _buildNavItem(Icons.search, "Cari", 1),

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
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
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
        return BerandaPeminjam(
          onAddToCart: _addToKeranjang,
        );
      case 1:
        return CariPeminjam(
          onAddToCart: _addToKeranjang,
        );
      case 2:
        return const RiwayatPeminjam();
      case 3:
        return const ProfilPeminjam();
      default:
        return Container();
    }
  }
}