import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showReceiptDialog(BuildContext context, Map<String, dynamic> data) {
  // Parsing data dari database
  final String idTrans = "#EDU-${data['id_peminjaman']}";
  final String namaUser = data['users']['username'] ?? "User";
  final String namaAlat = data['alat']['nama_alat'] ?? "Alat";
  final String tglPinjam = data['tanggal_pinjam'] ?? "-";
  final String tglTempo = data['batas_pengembalian'] ?? "-";

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Dialog
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF1A314D), Color(0xFF0D1B2A)]),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF2ECC71), size: 60),
                const SizedBox(height: 15),
                Text(
                  "Persetujuan Berhasil",
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
          
          // Body Dialog (Detail Data)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                _receiptRow("ID Transaksi", idTrans),
                _receiptRow("Peminjam", namaUser),
                _receiptRow("Alat", namaAlat),
                _receiptRow("Tgl Pinjam", tglPinjam),
                _receiptRow("Batas Kembali", tglTempo),
                
                const SizedBox(height: 20),
                const Divider(thickness: 1, color: Colors.black12),
                const SizedBox(height: 10),
                
                Text(
                  "Silakan simpan struk digital ini sebagai bukti peminjaman yang sah.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                ),
                
                const SizedBox(height: 25),
                
                // Tombol Aksi
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Tutup"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Integrasikan dengan package 'pdf' dan 'printing' jika diperlukan
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A314D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Unduh PDF"),
                      ),
                    ),
                  ],
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