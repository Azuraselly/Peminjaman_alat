// lib/admin/component/alat/alat_card.dart
import 'package:flutter/material.dart';
import 'package:inventory_alat/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class KategoriCard extends StatelessWidget {
  final String name;
  final String deskripsi;
  final String jumlah;
  final VoidCallback onDelete;
  final VoidCallback onTapDetail;

  const KategoriCard({
    super.key,
    required this.name,
    required this.deskripsi,
    required this.jumlah,
    required this.onDelete,
    required this.onTapDetail,
  });



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.abumud, width: 1),
        boxShadow: [
          BoxShadow(color: AppColors.abumud.withOpacity(0.35), blurRadius: 4),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.aulia,
                child: Text(
                  name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: AppColors.selly,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  Text(
                    deskripsi,
                    style: GoogleFonts.poppins(
                        color: AppColors.abuh,
                        fontSize: 13,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn("jumlah", jumlah, Colors.black), // Diubah dari TANGGAL ke jumlah
              const SizedBox(width: 15),
            ],
          ),
          const Divider(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onTapDetail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.form,
                    foregroundColor: Colors.black54,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "DETAIL",
                    style: GoogleFonts.poppins(
                        color: AppColors.abuh,
                        fontSize: 13,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _actionIcon(Icons.edit_outlined, Colors.blue, onTapDetail),
              const SizedBox(width: 10),
              _actionIcon(Icons.delete_outline, Colors.red, onDelete),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value, Color valColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.abuh,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: valColor,
          ),
        ),
      ],
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}