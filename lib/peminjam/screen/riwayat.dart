import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/peminjam/models/peminjam_models.dart';
import 'package:inventory_alat/service/peminjaman_service.dart';
import 'package:intl/intl.dart';

class RiwayatPeminjam extends StatefulWidget {
  const RiwayatPeminjam({super.key});

  @override
  State<RiwayatPeminjam> createState() => _RiwayatPeminjamState();
}

class _RiwayatPeminjamState extends State<RiwayatPeminjam> {
  final _service = PeminjamanService();
  List<PeminjamanItem> _riwayat = [];
  bool _isLoading = true;
  String _filterStatus = 'semua';

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  Future<void> _loadRiwayat() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getUserPeminjaman();
      setState(() {
        _riwayat = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat riwayat: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<PeminjamanItem> get _filteredRiwayat {
    if (_filterStatus == 'semua') return _riwayat;
    return _riwayat.where((item) => item.status == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterTabs(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadRiwayat,
              color: const Color(0xFF1A314D),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredRiwayat.isEmpty
                  ? _buildEmptyState()
                  : _buildRiwayatList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 160,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A314D), Color(0xFF2C5384)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Riwayat Transaksi",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${_riwayat.length} Total Transaksi",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      // Menghilangkan alignment center di container karena Row yang akan mengatur posisinya
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      height: 45,
      child: Row(
        // Ini kunci agar tab berada di tengah
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTabItem('semua', 'Semua'),
          const SizedBox(width: 8), // Beri jarak antar item
          _buildTabItem('diajukan', 'Proses'),
          const SizedBox(width: 8),
          _buildTabItem('disetujui', 'Aktif'),
          const SizedBox(width: 8),
          _buildTabItem('dikembalikan', 'Selesai'),
        ],
      ),
    );
  }

  Widget _buildTabItem(String value, String label) {
    final isSelected = _filterStatus == value;
    return GestureDetector(
      onTap: () => setState(() => _filterStatus = value),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A314D) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1A314D).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 5,
                  ),
                ],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildRiwayatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: _filteredRiwayat.length,
      itemBuilder: (context, index) {
        final item = _filteredRiwayat[index];
        return _buildRiwayatCard(item);
      },
    );
  }

  Widget _buildRiwayatCard(PeminjamanItem item) {
  final denda = item.hitungDenda; // Ambil data denda dari model

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      // Jika denda > 0, beri border merah tipis sebagai peringatan
      border: item.isLate && item.status != 'dikembalikan' 
          ? Border.all(color: Colors.red.shade200, width: 1) 
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column( // Ubah ke Column agar bisa menampung baris denda di bawah jika perlu
        children: [
          Row(
            children: [
              // Image Alat
              Container(
                width: 70, height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F9),
                  borderRadius: BorderRadius.circular(15),
                  image: item.gambarAlat != null
                      ? DecorationImage(image: NetworkImage(item.gambarAlat!), fit: BoxFit.cover)
                      : null,
                ),
                child: item.gambarAlat == null ? const Icon(Icons.inventory_2_outlined) : null,
              ),
              const SizedBox(width: 15),
              // Info Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.namaAlat,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Batas: ${DateFormat('dd MMM yyyy').format(item.batasPengembalian)}",
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${item.jumlah} Unit • ${item.kategori ?? 'Umum'}",
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF1A314D)),
                    ),
                  ],
                ),
              ),
              // Status Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: item.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.statusDisplay.toUpperCase(),
                      style: GoogleFonts.poppins(color: item.statusColor, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // --- BAGIAN DENDA ---
          if (item.isLate && item.status != 'dikembalikan') ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, thickness: 0.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      "Terlambat",
                      style: GoogleFonts.poppins(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  "Denda: Rp ${NumberFormat('#,###', 'id_ID').format(denda)}",
                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ]
        ],
      ),
    ),
  );
}
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/11329/11329060.png',
            height: 120,
            opacity: const AlwaysStoppedAnimation(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            "Tidak Ada Transaksi",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            "Coba ganti filter atau pinjam alat baru",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
