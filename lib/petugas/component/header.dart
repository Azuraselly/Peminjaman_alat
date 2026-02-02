import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildHeaderPetugas(String title) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
    decoration: const BoxDecoration(
      color: Color(0xFF1A314D),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 25, backgroundImage: NetworkImage('https://via.placeholder.com/150')),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Selamat Pagi,", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                Text("Azura Aulia", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const Spacer(),
            _headerIcon(Icons.notifications_none),
            const SizedBox(width: 10),
            _headerIcon(Icons.logout),
          ],
        ),
        const SizedBox(height: 25),
      
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              icon: const Icon(Icons.search, color: Colors.white70),
              hintText: "Cari nama siswa...",
              hintStyle: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _headerIcon(IconData icon) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
    child: Icon(icon, color: Colors.white, size: 20),
  );
}