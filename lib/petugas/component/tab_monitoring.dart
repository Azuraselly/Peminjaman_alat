import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/petugas/component/header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TabMonitoring extends StatelessWidget {
  final String userName;
  const TabMonitoring({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Column(
      children: [
        buildHeaderPetugas(userName),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            // 1. Sesuaikan primaryKey dan filter status 'disetujui'
            stream: supabase
                .from('peminjaman')
                .stream(primaryKey: ['id_peminjaman'])
                .eq('status', 'disetujui'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data ?? [];

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text("Monitoring Alat",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 15),
                  if (data.isEmpty)
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Belum ada alat yang dipinjam"),
                    )),
                  ...data.map((item) {
                    // 2. Logika Cek Terlambat
                    DateTime deadline = DateTime.parse(item['batas_pengembalian']);
                    bool isLate = deadline.isBefore(DateTime.now());

                    return _cardMonitoring(
                      context,
                      "ID Alat: ${item['id_alat']}",
                      "#KODE-${item['id_peminjaman']}",
                      "User: ${item['id_user'].toString().substring(0, 8)}",
                      item['batas_pengembalian'] ?? "-",
                      isLate,
                      item['id_peminjaman'],
                    );
                  }).toList(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _cardMonitoring(BuildContext context, String alat, String id,
      String nama, String tgl, bool isTerlambat, int idPeminjaman) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: isTerlambat ? const Color(0xFFFFEBEE) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isTerlambat ? Colors.red.shade100 : Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(alat,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                if (isTerlambat)
                  const Text("TERLAMBAT",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
              ],
            ),
            Text(id, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(children: [
              const CircleAvatar(radius: 12, child: Icon(Icons.person, size: 12)),
              const SizedBox(width: 8),
              Text(nama,
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w500)),
            ]),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.calendar_month, size: 14),
                  const SizedBox(width: 5),
                  Text("Batas: $tgl", style: const TextStyle(fontSize: 11))
                ]),
                ElevatedButton(
                  onPressed: () => _prosesKembali(context, idPeminjaman),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black12)),
                  child: const Text("KEMBALIKAN",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // 3. Fungsi untuk memproses pengembalian alat
  void _prosesKembali(BuildContext context, int id) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    try {
      // Update status peminjaman jadi 'dikembalikan'
      await supabase.from('peminjaman').update({
        'status': 'dikembalikan',
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id_peminjaman', id);

      // Tambahkan data ke tabel pengembalian sesuai skema
      await supabase.from('pengembalian').insert({
        'id_peminjaman': id,
        'tanggal_kembali': DateTime.now().toIso8601String(),
        'kondisi_saat_dikembalikan': 'baik', // Default atau bisa buat dialog input
        'diterima_oleh': user?.id,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alat berhasil dikembalikan!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memproses: $e")),
      );
    }
  }
}