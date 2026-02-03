import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/peminjam/models/peminjam_models.dart';
import 'package:inventory_alat/service/peminjaman_service.dart';

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
      print('Error loading riwayat: $e');
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "Riwayat Transaksi",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A314D),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadRiwayat,
        child: Column(
          children: [
            // Filter tabs
            _buildFilterTabs(),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredRiwayat.isEmpty
                      ? _buildEmptyState()
                      : _buildRiwayatList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _buildFilterTab('semua', 'Semua'),
          _buildFilterTab('diajukan', 'Proses'),
          _buildFilterTab('disetujui', 'Aktif'),
          _buildFilterTab('dikembalikan', 'Selesai'),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String value, String label) {
    final isSelected = _filterStatus == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _filterStatus = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A314D) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRiwayatList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: _filteredRiwayat.length,
      itemBuilder: (context, index) {
        final item = _filteredRiwayat[index];
        return _buildRiwayatCard(item);
      },
    );
  }

  Widget _buildRiwayatCard(PeminjamanItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE9EEF5),
              borderRadius: BorderRadius.circular(12),
              image: item.gambarAlat != null
                  ? DecorationImage(
                      image: NetworkImage(item.gambarAlat!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.gambarAlat == null
                ? const Icon(
                    Icons.assignment_outlined,
                    color: Color(0xFF1A314D),
                  )
                : null,
          ),
          const SizedBox(width: 15),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaAlat,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.tanggalPinjam.day}/${item.tanggalPinjam.month}/${item.tanggalPinjam.year}",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${item.jumlah} unit",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                if (item.isLate && item.status != 'dikembalikan')
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "TERLAMBAT",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: item.statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              item.statusDisplay,
              style: GoogleFonts.poppins(
                color: item.statusColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = _filterStatus == 'semua'
        ? "Belum ada riwayat transaksi"
        : "Tidak ada transaksi dengan status ini";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Mulai pinjam alat di beranda",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}