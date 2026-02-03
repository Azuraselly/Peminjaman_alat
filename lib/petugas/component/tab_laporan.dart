import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/petugas/component/header.dart';

class TabLaporan extends StatelessWidget {
  const TabLaporan({super.key, required String userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       buildHeaderPetugas("Laporan"),
        Expanded(
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(color: const Color(0xFFE8EEF5), borderRadius: BorderRadius.circular(30)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.description_outlined, size: 60, color: Colors.blueAccent),
                  const SizedBox(height: 20),
                  Text("Laporan Mingguan", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  const Text("Siapkan dokumen rekapan peminjam untuk diserahkan ke Admin", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.print, color: Colors.white),
                    label: const Text("Cetak Sekarang", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A314D), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}