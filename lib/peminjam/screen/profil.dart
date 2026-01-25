import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilPeminjamPage extends StatelessWidget {
  const ProfilPeminjamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A314D),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                child: Center(
                  child: Text("Profil Saya", style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const Positioned(
                bottom: -50,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFD1DCEB),
                    child: Icon(Icons.person, size: 60, color: Color(0xFF1A314D)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Text("Azura Aulia", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1A314D))),
          Text("XII TKR 1 • 222310101", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              children: [
                _buildProfileMenu(Icons.person_outline, "Informasi Akun"),
                _buildProfileMenu(Icons.lock_outline, "Ubah Password"),
                _buildProfileMenu(Icons.settings_outlined, "Pengaturan"),
                _buildProfileMenu(Icons.logout, "Keluar", color: Colors.red),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileMenu(IconData icon, String title, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(icon, color: color ?? const Color(0xFF1A314D)),
          const SizedBox(width: 15),
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: color)),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}