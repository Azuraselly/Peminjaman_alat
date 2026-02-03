import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityCard extends StatelessWidget {
  final int totalPeminjamanHariIni;
  final VoidCallback onTapCekLaporan;

  const ActivityCard({
    super.key,
    required this.totalPeminjamanHariIni,
    required this.onTapCekLaporan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 184,
      padding: const EdgeInsets.all(25),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF162D4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(45),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF162D4A).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Aktivitas Terkini",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            totalPeminjamanHariIni > 0
                ? "Ada $totalPeminjamanHariIni peminjaman baru hari ini"
                : "Belum ada aktivitas peminjaman hari ini",
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onTapCekLaporan,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2), // Lebih transparan agar elegan
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Colors.white, width: 1),
              ),
            ),
            child: Text(
              "CEK LAPORAN",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}