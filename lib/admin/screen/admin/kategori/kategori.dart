import 'package:flutter/material.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/kategori/add_kategori.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/kategori/kategori_card.dart';
import 'package:inventory_alat/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/screen/admin/kategori/detail_kategori.dart';
import 'package:inventory_alat/service/kategori_service.dart';

class Kategori extends StatefulWidget {
  const Kategori({super.key});

  @override
  State<Kategori> createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  final _kategoriService = KategoriService();
  List<Map<String, dynamic>> _kategoriList = [];
  List<Map<String, dynamic>> _filteredKategoriList = [];
  List<Map<String, dynamic>> _alatList = [];
  bool _isLoading = true;
  bool _showNotification = false;
  String _notificationMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadKategori();
  }

  Future<void> _loadKategori() async {
    try {
      setState(() => _isLoading = true);
      final data = await _kategoriService.getAllKategori();
      setState(() {
        _kategoriList = data;
        _filteredKategoriList = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showNotificationMessage('Gagal memuat data kategori', isError: true);
    }
  }

  void _searchKategori(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredKategoriList = _kategoriList;
      } else {
        _filteredKategoriList = _kategoriList.where((kategori) {
          return kategori['nama_kategori'].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
      }
    });
  }

  int _hitungJumlahAlat(int kategoriId) {
    return _alatList.where((alat) => alat['id_kategori'] == kategoriId).length;
  }

  void _showNotificationMessage(String message, {bool isError = false}) {
    setState(() {
      _notificationMessage = message;
      _showNotification = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showNotification = false);
    });
  }

  Future<void> _showAddKategoriDialog() async {
    final result = await showDialog(
      context: context,
      builder: (_) => const AddKategori(),
    );

    if (result != null) {
      try {
        await _kategoriService.addKategori(result);
        _showNotificationMessage(
          'Berhasil menambahkan kategori "${result['nama_kategori']}"',
        );
        _loadKategori();
      } catch (e) {
        _showNotificationMessage(
          'Gagal menambahkan kategori: $e',
          isError: true,
        );
      }
    }
  }

  Future<void> _showEditKategoriDialog(Map<String, dynamic> kategori) async {
    final result = await showDialog(
      context: context,
      builder: (_) => AddKategori(initialData: kategori),
    );

    if (result != null) {
      try {
        await _kategoriService.updateKategori(kategori['id_kategori'], result);
        _showNotificationMessage(
          'Berhasil mengupdate kategori "${result['nama_kategori']}"',
        );
        _loadKategori();
      } catch (e) {
        _showNotificationMessage(
          'Gagal mengupdate kategori: $e',
          isError: true,
        );
      }
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String kategori,
    VoidCallback onDelete,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            Text(
              "Konfirmasi Hapus",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Yakin ingin menghapus kategori \"$kategori\"?",
              style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 25),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      "Batal",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF3B71B9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 50, color: const Color(0xFFEEEEEE)),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onDelete();
                    },
                    child: Text(
                      "Hapus",
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      body: Stack(
        children: [
          Column(
            children: [
              const CustomHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
                child: Row(
                  children: [
                    _buildSquareBtn(
                      Icons.arrow_back,
                      () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "Manajemen Kategori",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    _buildSquareBtn(
                      Icons.add,
                      _showAddKategoriDialog,
                      color: const Color(0xFF3B71B9),
                      iconColor: Colors.white,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _searchKategori,
                        decoration: InputDecoration(
                          hintText: "Cari kategori...",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.abumud,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 18,
                            color: AppColors.abumud,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppColors.abumud,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredKategoriList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _searchController.text.isEmpty
                                  ? "Belum ada kategori"
                                  : "Kategori tidak ditemukan",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        itemCount: _filteredKategoriList.length,
                        itemBuilder: (context, index) {
                          final kategori = _filteredKategoriList[index];
                          final jumlahUnit = _hitungJumlahAlat(
                            kategori['id_kategori'],
                          );

                          return KategoriCard(
                            name: kategori['nama_kategori'] ?? '',
                            deskripsi: kategori['deskripsi_kategori'] ?? '-',
                            jumlah: "$jumlahUnit Unit",

                            onEdit: () => _showEditKategoriDialog(kategori),
                            onDelete: () => _showDeleteConfirmation(
                              context, // konteks saat ini
                              kategori['nama_kategori'], // nama kategori yang mau dihapus
                              () async {
                                try {
                                  await _kategoriService.deleteKategori(
                                    kategori['id_kategori'],
                                  );
                                  _showNotificationMessage(
                                    'Kategori "${kategori['nama_kategori']}" berhasil dihapus',
                                  );
                                  _loadKategori();
                                } catch (e) {
                                  _showNotificationMessage(
                                    'Gagal menghapus kategori: $e',
                                    isError: true,
                                  );
                                }
                              },
                            ),

                            onTapDetail: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DetailKategoriPage(),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          // Logika Notifikasi Melayang
          if (_showNotification)
            Positioned(
              top: 50, // Mengatur posisi munculnya notifikasi dari atas layar
              left: 20,
              right: 20,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF162D4A,
                    ).withOpacity(0.95), // Biru gelap transparan
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          _notificationMessage,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 1,
        onItemTapped: (index) {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildSquareBtn(
    IconData icon,
    VoidCallback onTap, {
    Color color = const Color(0xFFE8EEF5),
    Color iconColor = Colors.black87,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}
