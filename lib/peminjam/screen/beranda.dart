import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/peminjam/models/data.dart';

class BerandaContent extends StatefulWidget {
  final List<Alat> daftarAlat;
  final Function(Alat) onAddKeranjang;
  const BerandaContent({super.key, required this.daftarAlat, required this.onAddKeranjang, required void Function(dynamic alat) onAdd});

  @override
  State<BerandaContent> createState() => _BerandaContentState();
}

class _BerandaContentState extends State<BerandaContent> {
  String _searchQuery = "";
  String _selectedKategori = "Semua";

  @override
  Widget build(BuildContext context) {
    List<Alat> filteredAlat = widget.daftarAlat.where((alat) {
      final matchesSearch = alat.nama.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesKategori = _selectedKategori == "Semua" || alat.kategori == _selectedKategori;
      return matchesSearch && matchesKategori;
    }).toList();

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(25, 60, 25, 30),
          decoration: const BoxDecoration(
            color: Color(0xFF1A314D),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Selamat Pagi,", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                      Text("Azura Aulia", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                    ],
                  ),
                  const CircleAvatar(backgroundColor: Colors.white12, child: Icon(Icons.notifications_none, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Cari alat bengkel...",
                    hintStyle: GoogleFonts.poppins(color: Colors.white60),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Filter Kategori
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: ["Semua", "Kunci", "Elektrik", "Ukur", "Mesin", "Umum"].map((kategori) {
              final isSelected = _selectedKategori == kategori;
              return GestureDetector(
                onTap: () => setState(() => _selectedKategori = kategori),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1A314D) : const Color(0xFFE9EEF5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(kategori, style: GoogleFonts.poppins(color: isSelected ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              );
            }).toList(),
          ),
        ),
        // Grid Alat
        Expanded(
          child: filteredAlat.isEmpty
              ? const Center(child: Text("Alat tidak ditemukan."))
              : GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.75,
            ),
            itemCount: filteredAlat.length,
            itemBuilder: (context, i) {
              final alat = filteredAlat[i];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1DCEB), // Container biru muda kosong
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(child: Icon(Icons.handyman_outlined, color: Colors.white, size: 40)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alat.nama, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Stok: ${alat.stok}", style: GoogleFonts.poppins(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                              GestureDetector(
                                onTap: () {
                                  widget.onAddKeranjang(alat);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("${alat.nama} ditambahkan ke keranjang!")),
                                  );
                                },
                                child: const Icon(Icons.add_circle, color: Color(0xFF1A314D), size: 28),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
