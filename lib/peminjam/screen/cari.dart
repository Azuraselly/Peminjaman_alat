import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/peminjam/models/peminjam_models.dart';
import 'package:inventory_alat/service/peminjaman_service.dart';

class CariPeminjam extends StatefulWidget {
  final Function(Alat) onAddToCart;

  const CariPeminjam({super.key, required this.onAddToCart});

  @override
  State<CariPeminjam> createState() => _CariPeminjamState();
}

class _CariPeminjamState extends State<CariPeminjam> {
  final TextEditingController _searchController = TextEditingController();
  final _service = PeminjamanService();

  List<Alat> _searchResults = [];
  bool _isSearching = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (query.isNotEmpty) {
      _performSearch(query);
    }
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isLoading = true);

    try {
      final results = await _service.searchAlat(query);

      if (_searchController.text == query) {
        setState(() {
          _searchResults = results.map((e) => Alat.fromJson(e)).toList();
          _isLoading = false;
        });

        // Save to recent searches
        _service.addRecentSearch(query);
      }
    } catch (e) {
      print('Error searching: $e');
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mencari: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onRecentSearchTap(String query) {
    _searchController.text = query;
    _performSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // HEADER SEARCH
          _buildHeader(),

          // KONTEN BAWAH
          Expanded(
            child: _isSearching
                ? _buildSearchResults()
                : _buildRecentSearches(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
              decoration: InputDecoration(
                hintText: "Ketik nama alat...",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                icon: const Icon(Icons.search, color: Color(0xFF1A314D)),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _isSearching = false;
                            _searchResults = [];
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    final recentSearches = _service.getRecentSearches();

    return ListView(
      padding: const EdgeInsets.all(25),
      children: [
        if (recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pencarian Terakhir",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _service.clearRecentSearches();
                  });
                },
                child: Text(
                  "Hapus Semua",
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: recentSearches
                .map((tag) => _buildSearchTag(tag))
                .toList(),
          ),
          const SizedBox(height: 40),
        ],
        Center(
          child: Column(
            children: [
              Icon(
                Icons.manage_search_rounded,
                size: 80,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 10),
              Text(
                "Temukan alat yang Anda butuhkan\ndengan cepat dan mudah.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              "Alat tidak ditemukan",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Coba kata kunci lain",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final alat = _searchResults[index];
        return _buildSearchResultCard(alat);
      },
    );
  }

  Widget _buildSearchResultCard(Alat alat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFD1DCEB),
              borderRadius: BorderRadius.circular(12),
              image: alat.gambar != null
                  ? DecorationImage(
                      image: NetworkImage(alat.gambar!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: alat.gambar == null
                ? const Icon(Icons.build_outlined, color: Color(0xFF1A314D))
                : null,
          ),
          const SizedBox(width: 15),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alat.namaAlat,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Kategori: ${alat.kategori}",
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),

          // Stock and Add Button
          Column(
            children: [
              Text(
                "Stok: ${alat.stokAlat}",
                style: GoogleFonts.poppins(
                  color: alat.isAvailable ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: alat.isAvailable ? () => widget.onAddToCart(alat) : null,
                child: Icon(
                  Icons.add_circle,
                  color: alat.isAvailable
                      ? const Color(0xFF1A314D)
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTag(String label) {
    return GestureDetector(
      onTap: () => _onRecentSearchTap(label),
      child: Container(
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
      ),
    );
  }
}
