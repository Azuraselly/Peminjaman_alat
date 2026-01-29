import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/colors.dart'; // Pastikan file warna Anda sudah ada

class DetailAlatPage extends StatelessWidget {
  const DetailAlatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Biru Gelap (Reusable)
            _buildHeader(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(context, "Detail Alat"),
                  const SizedBox(height: 25),
                  
                  // Card Konten Utama
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Ikon Alat
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EEF5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.build_circle_outlined, 
                            size: 60, color: Color(0xFF3B71B9)),
                        ),
                        const SizedBox(height: 15),
                        Text("Dongkrak", 
                          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        
                        // Tags
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTag("ALAT-002"),
                            const SizedBox(width: 10),
                            _buildTag("SERVIS"),
                          ],
                        ),
                        const SizedBox(height: 30),
                        
                        // Stok dan Kondisi
                        Row(
                          children: [
                            Expanded(child: _buildInfoBox("STOK TERSEDIA", "10 Unit", null)),
                            const SizedBox(width: 15),
                            Expanded(child: _buildInfoBox("KONDISI", "Baik", Icons.check_circle_outline)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Deskripsi
                        _buildDescriptionBox("DESKRIPSI ALAT", "alattt otomotifff"),
                        const SizedBox(height: 30),
                        
                        // Tombol Aksi
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE8EEF5),
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  elevation: 0,
                                ),
                                child: Text("EDIT DATA", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 15),
                            _buildDeleteButton(() {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
       bottomNavigationBar: CustomNavbar(
        selectedIndex: 1,
        onItemTapped: (index) {
          Navigator.pop(context); 
        },
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 50, 25, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF162D4A),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 25, backgroundColor: Colors.grey),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Azura Aulia", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              Text("ADMIN", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.notifications_none, color: Colors.white),
          const SizedBox(width: 10),
          const Icon(Icons.logout, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, String title) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFE8EEF5), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back, size: 20),
          ),
        ),
        const SizedBox(width: 15),
        Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: const Color(0xFFE8EEF5), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.blueGrey)),
    );
  }

  Widget _buildInfoBox(String label, String value, IconData? icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFF1F4F8), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 5),
          Row(
            children: [
              if (icon != null) Icon(icon, size: 16, color: Colors.green),
              if (icon != null) const SizedBox(width: 5),
              Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: icon != null ? Colors.green : Colors.black87)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionBox(String label, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFF1F4F8), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(content, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
    );
  }

  buildHeaderWidget() {}

  buildBackButtonWidget(BuildContext context, String s) {}

  buildDeleteButtonWidget(Null Function() param0) {}
}