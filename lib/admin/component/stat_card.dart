import 'package:flutter/material.dart';
import 'package:inventory_alat/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({super.key, required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.abumud, width: 1),
        boxShadow: [BoxShadow(color: AppColors.abumud.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.abuh)),
                  Text(value, style: GoogleFonts.poppins(fontSize: 27, fontWeight: FontWeight.w800, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}