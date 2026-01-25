import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/petugas/component/header.dart';

class TabMonitoring extends StatelessWidget {
  const TabMonitoring({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       buildHeaderPetugas("Monitoring"),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text("Monitoring Alat", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              _cardMonitoring("Helm Safety", "Peminjaman #101", "Azura Selly", "18 JAN 2026", true),
              _cardMonitoring("Solder Listrik", "Peminjaman #102", "Daffa Arya", "19 JAN 2026", false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cardMonitoring(String alat, String id, String nama, String tgl, bool isTerlambat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: isTerlambat ? const Color(0xFFFFEBEE) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isTerlambat ? Colors.red.shade100 : Colors.black12),
      ),
      child: Stack(
        children: [
          if (isTerlambat)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: const BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.only(topRight: Radius.circular(18), bottomLeft: Radius.circular(18))),
                child: const Text("TERLAMBAT", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alat, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(id, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const CircleAvatar(radius: 12, child: Icon(Icons.person, size: 12)),
                    const SizedBox(width: 8),
                    Text(nama, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
                const Divider(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [const Icon(Icons.calendar_month, size: 14, color: Colors.blueGrey), const SizedBox(width: 5), Text(tgl, style: const TextStyle(fontSize: 11))]),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, elevation: 0, side: const BorderSide(color: Colors.black12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text("KONFIRMASI KEMBALI", style: TextStyle(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}