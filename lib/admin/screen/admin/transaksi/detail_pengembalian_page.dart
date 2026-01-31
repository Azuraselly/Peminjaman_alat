import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/navbar.dart';

class DetailPengembalianPage extends StatelessWidget {
  final String id;
  final String name;
  final String tool;
  final String date;
  final String condition;

  const DetailPengembalianPage({
    super.key,
    required this.id,
    required this.name,
    required this.tool,
    required this.date,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header profil Admin
          const CustomHeader(),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Back Button dan Title
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
                      Text("Detail PENGEMBALIAN",
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Main Detail Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
                    ),
                    child: Column(
                      children: [
                        // Status Icon Selesai
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB9F6CA),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded, size: 60, color: Color(0xFF279454)),
                        ),
                        const SizedBox(height: 15),
                        Text("Selesai", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w900)),
                        Text("ID: $id", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(),
                        ),

                        // Informasi Detail
                        _buildDetailRow("NAMA PEMINJAM", name),
                        const SizedBox(height: 20),
                        _buildDetailRow("ALAT DIKEMBALIKAN", tool),
                        const SizedBox(height: 20),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDetailRow("TGL KEMBALI", date),
                            _buildDetailRow("KONDISI", condition, isCondition: true),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Footer Persetujuan
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("DISETUJUI OLEH", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text("Admin ID: 1", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text("2026-01-18 09:30", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Tombol Aksi
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
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
      // Navbar tetap muncul di bawah
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 2,
        onItemTapped: (index) => Navigator.pop(context),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isCondition = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, 
            fontSize: 15,
            color: isCondition ? const Color(0xFF279454) : Colors.black, // Warna hijau untuk kondisi
          ),
        ),
      ],
    );
  }
}