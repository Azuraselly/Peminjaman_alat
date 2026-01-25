import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showReceiptDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1A314D),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 50),
                const SizedBox(height: 10),
                Text("Transaksi Berhasil", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _receiptRow("ID Transaksi", "#EDU-99283"),
                _receiptRow("Peminjam", "Azura Aulia"),
                _receiptRow("Alat", "Scanner OBD II"),
                _receiptRow("Tgl Pinjam", "18 Jan 2026"),
                _receiptRow("Jatuh Tempo", "20 Jan 2026"),
                const Divider(height: 30, thickness: 1),
                const Text("Tunjukkan struk ini kepada petugas saat pengembalian alat.", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text("Unduh Struk (PDF)"),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A314D), foregroundColor: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _receiptRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    ),
  );
}