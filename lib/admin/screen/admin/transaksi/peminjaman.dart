import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/transaksi/peminjaman/add_peminjaman.dart';
import 'package:inventory_alat/admin/component/transaksi/peminjaman/menu_item_card.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/service/peminjaman.dart';

class DataPeminjamanPage extends StatefulWidget {
  const DataPeminjamanPage({super.key});

  @override
  State<DataPeminjamanPage> createState() => _DataPeminjamanPageState();
}

class _DataPeminjamanPageState extends State<DataPeminjamanPage> {
  // Simulasi Nama Admin dari Login
  final String currentAdmin = "Admin Kece";

  // Fungsi Menampilkan Notifikasi Melayang (Overlay)
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
                      currentAdmin,
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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 20),
                _buildTitleRow(context),
                const SizedBox(height: 20),
                _buildSearchRow(),
                const SizedBox(height: 25),
                Expanded(
                  child: FutureBuilder(
                    future: PeminjamanService().getPeminjaman(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("Belum ada data peminjaman"),
                        );
                      }

                      final list = snapshot.data!;

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final item = list[i];

                          return MenuItemCard(
                            name: item['users']['username'],
                            tool: item['alat']['nama_alat'],
                            date: item['tanggal_pinjam'],
                            status: item['status'],
                            statusColor: item['status'] == 'dikembalikan'
                                ? Colors.green
                                : Colors.orange,

                            onEdit: () {
                              showDialog(
                                context: context,
                                builder: (_) => BuatPeminjamanDialog(
                                  isEdit: true,
                                  initialData: item, // WAJIB kirim item
                                ),
                              ).then(
                                (_) => setState(() {}),
                              ); // refresh otomatis
                            },

                            onDelete: () async {
                              final confirm = await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Hapus"),
                                  content: const Text("Yakin hapus data ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Batal"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Hapus"),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await PeminjamanService().deletePeminjaman(
                                  item['id_peminjaman'],
                                );

                                setState(() {}); // refresh list
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
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
            );
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
            decoration: InputDecoration(
              hintText: "Cari...",
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
        const SizedBox(width: 10),
        _iconButton(
          Icons.filter_list_alt,
          Colors.white,
          Colors.grey,
          border: true,
        ),
      ],
    );
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
}
