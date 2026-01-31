import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/colors.dart';

class AlatCard extends StatelessWidget {
  final String name;
  final String kategoriName;
  final String stok;
  final String kondisi;
  final bool isActive;
  final String? imageUrl; // ini URL gambar dari database
  final VoidCallback onDelete;
  final VoidCallback onTapDetail;
  final VoidCallback onEdit;

  const AlatCard({
    super.key,
    required this.name,
    required this.kategoriName,
    required this.stok,
    required this.kondisi,
    this.isActive = true,
    this.imageUrl,
    required this.onDelete,
    required this.onTapDetail,
    required this.onEdit,
  });

  // Helper untuk warna kondisi
  Color _getKondisiColor(String kondisi) {
    if (kondisi.toLowerCase().contains("baik")) return Colors.green;
    if (kondisi.toLowerCase().contains("ringan")) return Colors.orange;
    if (kondisi.toLowerCase().contains("berat")) return Colors.red;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.5, // memudar jika tidak aktif
      child: Container(
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
                // Gambar alat bulat
                CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.aulia,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // fallback ke huruf awal jika gagal load
                              return _initialAvatar();
                            },
                          )
                        : _initialAvatar(),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        kategoriName,
                        style: GoogleFonts.poppins(
                            color: AppColors.abuh,
                            fontSize: 13,
                            fontWeight: FontWeight.w900),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoColumn("STOK", stok, Colors.black),
                _infoColumn("KONDISI", kondisi, _getKondisiColor(kondisi)),
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
                      "LIHAT DETAIL",
                      style: GoogleFonts.poppins(
                          color: AppColors.abuh,
                          fontSize: 13,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _actionIcon(Icons.edit_outlined, Colors.blue, onEdit),
                const SizedBox(width: 10),
                _actionIcon(Icons.delete_outline, Colors.red, onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // fallback huruf awal jika tidak ada gambar
  Widget _initialAvatar() {
    return Container(
      color: AppColors.aulia,
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
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
