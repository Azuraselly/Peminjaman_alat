import 'package:flutter/material.dart';
import 'package:inventory_alat/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      padding: const EdgeInsets.fromLTRB(25, 50, 25, 30),
      decoration: BoxDecoration(
        color: AppColors.seli,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 4,
          offset: const Offset(0, 4)
        )]
      ),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 15),
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Azura Aulia", style: GoogleFonts.poppins(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w800)),
                Text("ADMIN", style: GoogleFonts.poppins(color: AppColors.selly, fontWeight: FontWeight.w800, fontSize: 16)),
              ],
            ),
          ),
          _buildIcon(Icons.notifications_none),
          const SizedBox(width: 10),
          _buildIcon(Icons.logout),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: AppColors.selly,
              padding: const EdgeInsets.all(15),
              child: const Icon(Icons.person, size: 45, color: AppColors.seli),
            ),
          ),
        ),
        const CircleAvatar(radius: 5, backgroundColor: Colors.green)
      ],
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: AppColors.abumud.withOpacity(0.25), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}