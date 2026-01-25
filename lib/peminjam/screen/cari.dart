import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CariPage extends StatefulWidget {
  const CariPage({super.key});

  @override
  State<CariPage> createState() => _CariPageState();
}

class _CariPageState extends State<CariPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> recentSearches = ["Kunci Momen", "Scanner OBD", "Mikrometer"];
  
  // Simulasi data hasil pencarian
  List<Map<String, String>> searchResults = [
    {"nama": "Kunci Momen Digital", "kat": "Kunci", "stok": "3"},
    {"nama": "Kunci Pas 12mm", "kat": "Kunci", "stok": "10"},
  ];

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // HEADER SEARCH (NAVY)
          Container(
            padding: const EdgeInsets.fromLTRB(25, 60, 25, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF1A314D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Eksplorasi Alat",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        isSearching = val.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Ketik nama alat...",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                      icon: const Icon(Icons.search, color: Color(0xFF1A314D)),
                      suffixIcon: isSearching 
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => isSearching = false);
                            },
                          )
                        : null,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // KONTEN BAWAH
          Expanded(
            child: isSearching ? _buildSearchResults() : _buildRecentSearches(),
          ),
        ],
      ),
    );
  }

  // TAMPILAN JIKA TIDAK SEDANG MENGETIK (Pencarian Terakhir)
  Widget _buildRecentSearches() {
    return ListView(
      padding: const EdgeInsets.all(25),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pencarian Terakhir",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              "Hapus Semua",
              style: GoogleFonts.poppins(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: recentSearches.map((tag) => _buildSearchTag(tag)).toList(),
        ),
        const SizedBox(height: 40),
        Center(
          child: Column(
            children: [
              Icon(Icons.manage_search_rounded, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 10),
              Text(
                "Temukan alat yang Anda butuhkan\ndengan cepat dan mudah.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        )
      ],
    );
  }

  // TAMPILAN HASIL PENCARIAN (LIST STYLE)
  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final item = searchResults[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1DCEB), // Biru muda kosong
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.build_outlined, color: Color(0xFF1A314D)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nama']!,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      "Kategori: ${item['kat']}",
                      style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    "Stok: ${item['stok']}",
                    style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  const SizedBox(height: 5),
                  const Icon(Icons.add_circle, color: Color(0xFF1A314D)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history, size: 14, color: Colors.grey),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}