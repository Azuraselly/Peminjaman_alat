import 'package:flutter/material.dart';
import 'package:inventory_alat/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const MenuItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 372,
      height: 122,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.abumud, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        
        leading: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.aulia,
            borderRadius: BorderRadius.circular(15),
          ),
          
          child: Icon(
            icon, color: AppColors.selly, size: 31),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.abuh, fontWeight:FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.abuh, size: 22),
        onTap: onTap,
      ),
    );
  }
}