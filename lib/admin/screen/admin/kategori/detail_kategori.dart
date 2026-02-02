import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/navbar.dart';

// Catatan: Anda bisa memanggil komponen Header dari file DetailAlatPage agar tidak duplikasi
class DetailKategoriPage extends StatelessWidget {
  const DetailKategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header sama dengan DetailAlat
            _buildPlaceholderHeader(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  _buildTopNav(context, "Detail Kategori"),
                  const SizedBox(height: 40),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color:  Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        // Ikon Kategori
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F4F8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.handyman_outlined, 
                            size: 60, color: Color(0xFF3B71B9)),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "K3",
                          style: GoogleFonts.poppins(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // Deskripsi
                        _buildDescBox("DESKRIPSI KATEGORI", "allattt otomotifff"),
                        const SizedBox(height: 30),
                        
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF1F4F8),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    "EDIT DATA",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            _buildDeleteBtn(),
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
          Navigator.pop(context); // Kembali ke navigasi utama
        },
      ),
    );
  }

  // Widget helpers minimalis (sesuai desain gambar ke-3)
  Widget _buildPlaceholderHeader() {
    return Container(
      height: 150,
      decoration: const BoxDecoration(
        color: Color(0xFF162D4A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
    );
  }

  Widget _buildTopNav(BuildContext context, String title) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          style: IconButton.styleFrom(backgroundColor: const Color(0xFFF1F4F8)),
        ),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDescBox(String label, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(15),
      ),
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
          const SizedBox(height: 8),
          Text(content, style: GoogleFonts.poppins(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildDeleteBtn() {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.red),
    );
  }
}