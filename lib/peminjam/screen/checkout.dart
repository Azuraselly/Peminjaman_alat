import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/peminjam/models/data.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key, required List<Alat> items, required void Function(dynamic index) onRemove, required Null Function() onCheckout, required List<Alat> keranjangItems, required void Function(dynamic index) onRemoveKeranjang});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  // Data dummy keranjang
  List<Map<String, dynamic>> cartItems = [
    {"nama": "Kunci Momen Digital", "jumlah": 1, "kategori": "Kunci"},
    {"nama": "Scanner OBD II", "jumlah": 1, "kategori": "Elektrik"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // 1. HEADER KERANJANG
      appBar: AppBar(
        title: Text(
          "Keranjang Pinjam",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF1A314D),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      body: Column(
        children: [
          // 2. LIST ITEM KERANJANG
          Expanded(
            child: cartItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) => _buildCartCard(index),
                  ),
          ),
        ],
      ),

      // 3. AREA ESTIMASI (Diatas Navbar)
      bottomSheet: _buildCheckoutPanel(),
    );
  }

  Widget _buildCartCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Placeholder Gambar Biru Muda
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFD1DCEB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.build_rounded, color: Color(0xFF1A314D)),
          ),
          const SizedBox(width: 15),
          // Detail Alat
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItems[index]['nama'],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Kategori: ${cartItems[index]['kategori']}",
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(
                  "${cartItems[index]['jumlah']} Unit",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1A314D),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Tombol Hapus
          IconButton(
            onPressed: () {
              setState(() {
                cartItems.removeAt(index);
              });
            },
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          )
        ],
      ),
    );
  }

  Widget _buildCheckoutPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Estimasi Pengembalian:",
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  Text("28 Januari 2026",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A314D),
                      )),
                ],
              ),
              const Icon(Icons.calendar_month, color: Color(0xFF1A314D)),
            ],
          ),
          const SizedBox(height: 20),
          // Ruang kosong untuk tombol melayang dari Navbar nantinya
          const SizedBox(height: 50), 
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            "Keranjangmu kosong",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            "Pilih alat di beranda untuk meminjam",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}