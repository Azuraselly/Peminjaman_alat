import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/transaksi/peminjaman/add_peminjaman.dart';

class DetailPeminjamanPage extends StatelessWidget {
  const DetailPeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                                Text("#102", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w900)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFFDDE7F2), borderRadius: BorderRadius.circular(20)),
                              child: Text("DISETUJUI", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF3B6790))),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        _buildInfoTile(Icons.person_outline, "Azura", "XI TKR 1"),
                        const SizedBox(height: 12),
                        _buildInfoTile(Icons.handyman_outlined, "Dongkrak", "JML: 1     ID ALAT: 3"),
                        
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDateInfo("TGL PINJAM", "2026-01-18", Colors.black),
                            _buildDateInfo("BATAS KEMBALI", "2026-01-19", Colors.red),
                          ],
                        ),
                        const Divider(height: 40),
                        
                        Text("DISETUJUI OLEH", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text("Admin ID: 1", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text("2026-01-18 08:30", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                        
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // POP-UP EDIT DATA
                                  showDialog(
                                    context: context,
                                    builder: (context) => const BuatPeminjamanDialog(
                                      isEdit: true,
                                      initialData: {
                                        'name': 'Azura',
                                        'tool': 'Dongkrak',
                                        'kelas': 'XI TKR 1',
                                        'date': '2026-01-18',
                                      },
                                    ),
                                  );
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
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: const Color(0xFFFFDADA), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.delete_outline, color: Colors.red),
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
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 2, // Highlight pada menu Transaksi
        onItemTapped: (index) {
          Navigator.pop(context); // Kembali ke navigasi utama
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
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