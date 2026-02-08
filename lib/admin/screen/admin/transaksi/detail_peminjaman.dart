import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/transaksi/peminjaman/add_peminjaman.dart';
import 'package:inventory_alat/service/peminjaman_service.dart'; // Pastikan path benar

class DetailPeminjamanPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailPeminjamanPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Parsing data dari database
    final int id = data['id_peminjaman'] ?? 0;
    final String username = data['users']?['username'] ?? 'User';
    final String toolName = data['alat']?['nama_alat'] ?? 'Alat';
    final String kelas = data['tingkatan_kelas'] ?? '-';
    final String status = data['status'] ?? 'diajukan';
    final String tglPinjam = data['tanggal_pinjam'] ?? '-';
    final String tglKembali = data['batas_pengembalian'] ?? '-';
    final int jumlah = data['jumlah'] ?? 0;
    final int idAlat = data['id_alat'] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          const CustomHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Back Button and Title
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text("Detail Peminjaman",
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Main Detail Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ID TRANSAKSI", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                Text("#$id", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w900)),
                              ],
                            ),
                            _buildStatusBadge(status),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        _buildInfoTile(Icons.person_outline, username, kelas),
                        const SizedBox(height: 12),
                        _buildInfoTile(Icons.handyman_outlined, toolName, "JML: $jumlah    ID ALAT: $idAlat"),
                        
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDateInfo("TGL PINJAM", tglPinjam, Colors.black),
                            _buildDateInfo("BATAS KEMBALI", tglKembali, Colors.red),
                          ],
                        ),
                        const Divider(height: 40),
                        
                        Text("DISETUJUI OLEH", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        // Menampilkan nama admin/petugas yang menyetujui jika ada
                        Text(data['disetujui_oleh_name'] ?? "Menunggu Persetujuan", 
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(data['waktu_setujui'] ?? "-", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                        
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final result = await showDialog(
                                    context: context,
                                    builder: (context) => BuatPeminjamanDialog(
                                      isEdit: true,
                                      initialData: data,
                                    ),
                                  );
                                  if (result == true) Navigator.pop(context, true);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEEEEEE),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text("EDIT DATA", style: GoogleFonts.poppins(color: Colors.black54, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => _confirmDelete(context, id),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: const Color(0xFFFFDADA), borderRadius: BorderRadius.circular(12)),
                                child: const Icon(Icons.delete_outline, color: Colors.red),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'disetujui': color = Colors.blue; break;
      case 'ditolak': color = Colors.red; break;
      case 'dikembalikan': color = Colors.green; break;
      default: color = Colors.orange; // diajukan
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(status.toUpperCase(), 
          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }

  // Fungsi hapus data
  void _confirmDelete(BuildContext context, int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Yakin ingin menghapus transaksi ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await PeminjamanService().deletePeminjaman(id);
      Navigator.pop(context, true); // Kembali ke list dan refresh
    }
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF1F1F1), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.grey),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDateInfo(String label, String date, Color dateColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(date, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: dateColor)),
      ],
    );
  }
}