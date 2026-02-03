import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/transaksi/peminjaman/add_peminjaman.dart';
import 'package:inventory_alat/admin/component/transaksi/peminjaman/menu_item_card.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/service/peminjaman_service.dart';

class DataPeminjamanPage extends StatefulWidget {
  const DataPeminjamanPage({super.key});

  @override
  State<DataPeminjamanPage> createState() => _DataPeminjamanPageState();
}

class _DataPeminjamanPageState extends State<DataPeminjamanPage> {
  String currentAdmin = "Admin";
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    final profile = await PeminjamanService().getUserProfile();
    if (profile != null && mounted) {
      setState(() {
        currentAdmin = profile['username'] ?? "Admin";
      });
    }
  }

  void _showTopNotif(String message) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF162D4A),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentAdmin, // Sekarang otomatis berubah
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      message,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () => overlayEntry.remove());
  }

  // Fungsi Dialog Konfirmasi Hapus
  void _confirmDelete(String targetName, String namaData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Hapus Data",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text("Yakin ingin menghapus data peminjaman $targetName?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _showTopNotif("Berhasil menghapus data $namaData");
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          const CustomHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildTitleRow(context),
                const SizedBox(height: 20),
                _buildSearchRow(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: PeminjamanService().getPeminjaman(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Belum ada data peminjaman"));
                }

                // Logika Filter Pencarian Sederhana
                final list = snapshot.data!.where((item) {
                  final name = item['users']['username']
                      .toString()
                      .toLowerCase();
                  return name.contains(_searchQuery.toLowerCase());
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final item = list[i];

                    return MenuItemCard(
                      // Sesuai dengan struktur query di Service (item['users']['username'])
                      name: item['users'] != null
                          ? item['users']['username']
                          : "Unknown",
                      tool: item['alat'] != null
                          ? item['alat']['nama_alat']
                          : "Alat Dihapus",
                      date: item['tanggal_pinjam'] ?? "-",
                      status: item['status'] ?? "pending",
                      statusColor: item['status'] == 'dikembalikan'
                          ? Colors.green
                          : Colors.orange,
                      fullData: item,
                      onEdit: () {
                        showDialog(
                          context: context,
                          builder: (_) => BuatPeminjamanDialog(
                            isEdit: true,
                            initialData: item, // item adalah Map dari database
                          ),
                        ).then((value) {
                          if (value == true) setState(() {});
                        });
                      },
                      onDelete: () async {
                        _confirmDeleteAction(
                          item['id_peminjaman'],
                          item['users']['username'],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 2,
        onItemTapped: (i) => Navigator.pop(context),
      ),
    );
  }

  void _confirmDeleteAction(int id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Data"),
        content: Text("Yakin ingin menghapus data $name?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await PeminjamanService().deletePeminjaman(id);
      _showTopNotif("Berhasil menghapus data $name");
      setState(() {});
    }
  }

  void _openEditDialog(String name) {
    showDialog(
      context: context,
      builder: (context) => const BuatPeminjamanDialog(isEdit: true),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _iconButton(
              Icons.arrow_back,
              Colors.grey.shade200,
              Colors.black,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: 15),
            Text(
              "Data Peminjaman",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        _iconButton(
          Icons.add,
          const Color(0xFF3B6790),
          Colors.white,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const BuatPeminjamanDialog(isEdit: false),
            ).then((value) {
              // REFRESH DI SINI
              setState(() {});
            });
          },
        ),
      ],
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (val) =>
                setState(() => _searchQuery = val), // Trigger refresh list
            decoration: InputDecoration(
              hintText: "Cari nama peminjam...",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _iconButton(
  IconData icon,
  Color bg,
  Color iconColor, {
  bool border = false,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: border ? Border.all(color: Colors.grey.shade200) : null,
      ),
      child: Icon(icon, color: iconColor, size: 24),
    ),
  );
}
