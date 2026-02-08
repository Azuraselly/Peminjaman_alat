import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/auth/login_page.dart';
import 'package:inventory_alat/peminjam/models/peminjam_models.dart';
import 'package:inventory_alat/peminjam/screen/beranda.dart';
import 'package:inventory_alat/peminjam/screen/profil.dart';
import 'package:inventory_alat/peminjam/screen/riwayat.dart';
import 'package:inventory_alat/peminjam/screen/checkout.dart';

class MainNavigationPeminjam extends StatefulWidget {
  const MainNavigationPeminjam({super.key});

  @override
  State<MainNavigationPeminjam> createState() => _MainNavigationPeminjamState();
}

class _MainNavigationPeminjamState extends State<MainNavigationPeminjam> {
  int _currentIndex = 0;
  final List<KeranjangItem> _keranjang = [];

  // --- LOGIKA KERANJANG ---
  void _addToKeranjang(Alat alat) {
    setState(() {
      final existingIndex = _keranjang.indexWhere((item) => item.alat.idAlat == alat.idAlat);

      if (existingIndex >= 0) {
        if (_keranjang[existingIndex].canIncrease) {
          _keranjang[existingIndex].jumlah++;
          _showCustomSnackBar('${alat.namaAlat} ditambahkan (${_keranjang[existingIndex].jumlah})', Colors.green);
        } else {
          _showCustomSnackBar('Stok ${alat.namaAlat} habis', Colors.orange);
        }
      } else {
        _keranjang.add(KeranjangItem(alat: alat, jumlah: 1));
        _showCustomSnackBar('${alat.namaAlat} masuk keranjang!', Colors.blue);
      }
    });
  }

  void _showCustomSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // --- LOGIKA LOGOUT ---
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Logout", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Apakah Anda yakin ingin keluar?", style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: Text("Keluar", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF8F9FA),

      // 1. FAB: KERANJANG DI TENGAH
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_keranjang.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KeranjangPeminjam(
                  items: _keranjang,
                  onRemove: (i) => setState(() => _keranjang.removeAt(i)),
                  onUpdateQuantity: (i, q) => setState(() => _keranjang[i].jumlah = q),
                  onClearCart: () => setState(() => _keranjang.clear()),
                ),
              ),
            );
          } else {
            _showCustomSnackBar("Keranjangmu masih kosong.", Colors.black87);
          }
        },
        backgroundColor: const Color(0xFF1A314D),
        elevation: 6,
        shape: const CircleBorder(),
        child: Badge(
          isLabelVisible: _keranjang.isNotEmpty,
          label: Text(_keranjang.length.toString(), style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
          child: const Icon(Icons.shopping_basket_rounded, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 2. BOTTOM NAVBAR: RAPI & SIMETRIS
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Sisi Kiri
            Row(
              children: [
                _buildNavItem(Icons.home_rounded, "Beranda", 0),
                _buildNavItem(Icons.assignment_rounded, "Riwayat", 1),
              ],
            ),
            // Sisi Kanan
            Row(
              children: [
                _buildNavItem(Icons.person_rounded, "Profil", 2),
                _buildNavItem(Icons.logout_rounded, "Keluar", 3),
              ],
            ),
          ],
        ),
      ),

      // 3. BODY DENGAN FADE TRANSITION
      body: PageTransitionSwitcher(
        child: _buildPageContent(),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    // Tombol logout (index 3) tidak mengubah currentIndex tapi memicu fungsi logout
    bool isActive = _currentIndex == index;
    bool isLogout = index == 3;

    return SizedBox(
      width: MediaQuery.of(context).size.width / 5, // Membagi layar secara rata
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isLogout) {
              _handleLogout();
            } else {
              setState(() => _currentIndex = index);
            }
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFF1A314D) : Colors.grey[400],
                size: 26,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? const Color(0xFF1A314D) : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_currentIndex) {
      case 0: return BerandaPeminjam(onAddToCart: _addToKeranjang);
      case 1: return const RiwayatPeminjam();
      case 2: return ProfilPeminjam(onLogout: _handleLogout);
      default: return BerandaPeminjam(onAddToCart: _addToKeranjang);
    }
  }
}

// Helper sederhana untuk transisi halaman agar tidak kaku
class PageTransitionSwitcher extends StatelessWidget {
  final Widget child;
  const PageTransitionSwitcher({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: child,
    );
  }
}