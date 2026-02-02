import 'package:flutter/material.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/alat/add_alat.dart';
import 'package:inventory_alat/admin/component/alat/alat_card.dart';
import 'package:inventory_alat/admin/screen/admin/alat/detail_alat.dart';
import 'package:inventory_alat/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/service/alat_service.dart';
import 'package:inventory_alat/service/kategori_service.dart';

class ManajemenAlatPage extends StatefulWidget {
  const ManajemenAlatPage({super.key});
  @override
  State<ManajemenAlatPage> createState() => _ManajemenAlatPageState();
}

class _ManajemenAlatPageState extends State<ManajemenAlatPage> {
  final AlatService _alatService = AlatService();
  final KategoriService _kategoriService = KategoriService();
  List<Map<String, dynamic>> _allAlat = [];
  bool _isLoading = false;
  bool _showNotification = false;
  String _notifMessage = "";
  bool _notifIsSuccess = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
    // Setup realtime listeners
    _setupRealtimeListeners();
  }

  void _setupRealtimeListeners() {
    // Listen for alat changes
    _alatService.client.from('alat').stream(primaryKey: ['id_alat']).listen((
      _,
    ) {
      _loadAlat();
    });

    // Listen for kategori changes
    _kategoriService.client
        .from('kategori')
        .stream(primaryKey: ['id_kategori'])
        .listen((_) {
          _loadKategori();
        });
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    try {
      await Future.wait([_loadAlat(), _loadKategori()]);
    } catch (e) {
      _showNotificationMessage("Gagal memuat data: ${e.toString()}", false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadAlat() async {
    try {
      final data = await _alatService.getAllAlat();
      setState(() {
        _allAlat = data.map((e) {
          // Safely handle category data
          final kategoriData = e['kategori'];
          int categoryId = 0;
          String categoryName = '-';

          if (kategoriData != null) {
            if (kategoriData is Map<String, dynamic>) {
              categoryId = kategoriData['id_kategori'] is int
                  ? kategoriData['id_kategori']
                  : int.tryParse(
                          kategoriData['id_kategori']?.toString() ?? '0',
                        ) ??
                        0;
              categoryName = kategoriData['nama_kategori']?.toString() ?? '-';
            }
          }

          return {
            'id_alat': e['id_alat'] is int
                ? e['id_alat']
                : int.tryParse(e['id_alat']?.toString() ?? '0') ?? 0,
            'nama_alat': e['nama_alat']?.toString() ?? '',
            'kategori': {
              'id_kategori': categoryId,
              'nama_kategori': categoryName,
            },
            'id_kategori': categoryId,
            'stok_alat': e['stok_alat'] is int
                ? e['stok_alat']
                : int.tryParse(e['stok_alat']?.toString() ?? '0') ?? 0,
            'kondisi_alat': e['kondisi_alat']?.toString() ?? '',
            'deskripsi': e['deskripsi']?.toString() ?? '',
            'gambar': e['gambar']?.toString(),
            'created_at': e['created_at']?.toString(),
          };
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to load alat: $e');
    }
  }

  Future<void> _loadKategori() async {
    try {
      // Load kategori but don't store in state since we're not using it in UI
      await _kategoriService.getAllKategori();
    } catch (e) {
      throw Exception('Failed to load kategori: $e');
    }
  }

  void _openForm({Map<String, dynamic>? item, int? index}) {
    showDialog(
      context: context,
      builder: (_) => AddAlat(
        initialData: item,
        onShowNotification: _showNotificationMessage,
      ),
    ).then((_) {
      // Refresh data after dialog closes
      _loadAlat();
    });
  }

  void _deleteAlat(int index) async {
    setState(() => _isLoading = true);
    try {
      final result = await _alatService.deleteAlat(_allAlat[index]['id_alat']);
      if (result['success'] == true) {
        _showNotificationMessage(
          "Berhasil menghapus ${_allAlat[index]['nama_alat']}",
          true,
        );
        // Reload data to ensure UI is updated
        await _loadAlat();
      }
    } catch (e) {
      _showNotificationMessage("Gagal menghapus: ${e.toString()}", false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showNotificationMessage(String message, bool isSuccess) {
    setState(() {
      _notifMessage = message;
      _notifIsSuccess = isSuccess;
      _showNotification = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showNotification = false);
    });
  }

  void _showDeleteConfirmation(String name) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
              "Yakin ingin menghapus?",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 25),
            const Divider(height: 1, thickness: 1),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Batal",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF3B71B9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.grey.shade300,
                ), // Garis vertikal tengah
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Find the correct index of the item to delete
                      int itemIndex = _allAlat.indexWhere(
                        (item) => item['nama_alat'] == name,
                      );
                      if (itemIndex != -1) {
                        _deleteAlat(itemIndex);
                      }
                    },
                    child: Text(
                      "Hapus",
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
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
                      "Manajemen Alat",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    // Di dalam ManajemenAlatPage
                    _buildSquareBtn(
                      Icons.add,
                      () => _openForm(),
                      color: const Color(0xFF3B71B9),
                      iconColor: Colors.white,
                    ),
                  ],
                ),
              ),
              // Search & Filter
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Cari...",
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
                    const SizedBox(width: 10),
                    _buildSquareBtn(Icons.filter, () {}, color: Colors.white),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _allAlat.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada data alat',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tekan tombol + untuk menambah alat baru',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        itemCount: _allAlat.length,
                        itemBuilder: (context, index) {
                          final item = _allAlat[index];
                          return AlatCard(
                            name: item['nama_alat'],
                            kategoriName:
                                item['kategori']?['nama_kategori'] ?? '-',
                            stok: '${item['stok_alat']} Unit',
                            kondisi: item['kondisi_alat'],
                            imageUrl: item['gambar'],
                            onDelete: () {
                              _showDeleteConfirmation(item['nama_alat']);
                            },
                            onTapDetail: () {
                              // Navigate to detail page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailAlatPage(alatData: item),
                                ),
                              );
                            },
                            onEdit: () {
                              showDialog(
                                context: context,
                                builder: (_) => AddAlat(
                                  initialData: item,
                                  onShowNotification: _showNotificationMessage,
                                ),
                              ).then((_) {
                                _loadAlat();
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
          if (_showNotification)
            Positioned(
              top: 60,
              left: 25,
              right: 25,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: _notifIsSuccess
                        ? const Color(0xFF3B71B9).withOpacity(0.9)
                        : Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _notifIsSuccess ? Icons.check_circle : Icons.error,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _notifIsSuccess ? "Sukses" : "Error",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _notifMessage,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ],
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
          Navigator.pop(context); // Kembali ke navigasi utama
        },
      ),
    );
  }
}
