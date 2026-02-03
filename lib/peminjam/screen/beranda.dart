import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/peminjam/models/peminjam_models.dart';
import 'package:inventory_alat/service/peminjaman_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BerandaPeminjam extends StatefulWidget {
  final Function(Alat) onAddToCart;

  const BerandaPeminjam({
    super.key,
    required this.onAddToCart,
  });

  @override
  State<BerandaPeminjam> createState() => _BerandaPeminjamState();
}

class _BerandaPeminjamState extends State<BerandaPeminjam> {
  final _service = PeminjamanService();
  
  List<Alat> _daftarAlat = [];
  List<Kategori> _daftarKategori = [];
  bool _isLoading = true;
  String _searchQuery = "";
  int? _selectedKategoriId;
  String _selectedKategoriName = "Semua";
  String? _userName;
  int _activePeminjamanCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // Load user profile
      final profile = await _service.getUserProfile();
      
      // Load alat and kategori in parallel
      final results = await Future.wait([
        _service.getAlat(),
        _service.getAllKategori(),
        _service.getActivePeminjamanCount(),
      ]);

      setState(() {
        _daftarAlat = results[0] as List<Alat>;
        _daftarKategori = results[1] as List<Kategori>;
        _activePeminjamanCount = results[2] as int;
        _userName = profile?['username'] as String?;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Alat> get _filteredAlat {
    return _daftarAlat.where((alat) {
      final matchesSearch = alat.namaAlat
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesKategori = _selectedKategoriId == null ||
          alat.idKategori == _selectedKategoriId;
      return matchesSearch && matchesKategori;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Filter Kategori
          const SizedBox(height: 20),
          _buildKategoriFilter(),
          
          // Grid Alat
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAlat.isEmpty
                    ? _buildEmptyState()
                    : _buildAlatGrid(),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    _userName ?? 'Loading...',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white12,
                    child: Icon(
                      Icons.assignment_outlined,
                      color: Colors.white,
                    ),
                  ),
                  if (_activePeminjamanCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          _activePeminjamanCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
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
    );
  }

  Widget _buildKategoriFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // "Semua" button
          _buildKategoriChip(null, "Semua"),
          // Kategori buttons
          ..._daftarKategori.map((kategori) => 
            _buildKategoriChip(kategori.idKategori, kategori.namaKategori)
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriChip(int? kategoriId, String nama) {
    final isSelected = _selectedKategoriId == kategoriId;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedKategoriId = kategoriId;
        _selectedKategoriName = nama;
      }),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A314D) : const Color(0xFFE9EEF5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          nama,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildAlatGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredAlat.length,
      itemBuilder: (context, index) {
        final alat = _filteredAlat[index];
        return _buildAlatCard(alat);
      },
    );
  }

  Widget _buildAlatCard(Alat alat) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFD1DCEB),
                borderRadius: BorderRadius.circular(15),
                image: alat.gambar != null
                    ? DecorationImage(
                        image: NetworkImage(alat.gambar!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: alat.gambar == null
                  ? const Center(
                      child: Icon(
                        Icons.handyman_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    )
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
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
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Stok: ${alat.stokAlat}",
                      style: GoogleFonts.poppins(
                        color: alat.isAvailable ? Colors.green : Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: alat.isAvailable
                          ? () => widget.onAddToCart(alat)
                          : null,
                      child: Icon(
                        Icons.add_circle,
                        color: alat.isAvailable
                            ? const Color(0xFF1A314D)
                            : Colors.grey,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[300],
          ),
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
            "Coba kata kunci atau kategori lain",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi,';
    if (hour < 15) return 'Selamat Siang,';
    if (hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }
}