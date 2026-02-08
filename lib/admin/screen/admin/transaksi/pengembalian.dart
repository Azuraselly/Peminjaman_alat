import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/transaksi/pengembalian/BuatPengembalianDialog.dart';
import 'package:inventory_alat/admin/screen/admin/transaksi/detail_pengembalian_page.dart';
import 'package:inventory_alat/service/pengembalian_service.dart';

class DataPengembalianPage extends StatefulWidget {
  const DataPengembalianPage({super.key});

  @override
  State<DataPengembalianPage> createState() => _DataPengembalianPageState();
}

class _DataPengembalianPageState extends State<DataPengembalianPage> {
  final PengembalianService _service = PengembalianService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Fungsi untuk konfirmasi hapus
  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Hapus Data", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Apakah Anda yakin ingin menghapus data pengembalian #$id?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _service.deletePengembalian(int.parse(id));
                setState(() {}); 
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Data berhasil dihapus"), backgroundColor: Colors.green),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menghapus: $e"), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
            child: RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER ---
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          "Data Pengembalian",
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        const Spacer(),
                        _buildAddButton(context),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- SEARCH BAR ---
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Cari nama peminjam atau alat...",
                          hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF3B6790)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // --- LIST DATA ---
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _service.getListPengembalian(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("Tidak ada data pengembalian"));
                        }

                        // Logika Filtering
                        final filteredList = snapshot.data!.where((item) {
                          final p = item['peminjaman'];
                          final user = (p?['users']?['username'] ?? "").toString().toLowerCase();
                          final alat = (p?['alat']?['nama_alat'] ?? "").toString().toLowerCase();
                          final id = item['id_pengembalian'].toString().toLowerCase();

                          return user.contains(_searchQuery) || 
                                 alat.contains(_searchQuery) || 
                                 id.contains(_searchQuery);
                        }).toList();

                        if (filteredList.isEmpty) {
                          return const Center(child: Text("Hasil pencarian tidak ditemukan"));
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            final p = item['peminjaman'];
                            final user = p?['users']?['username'] ?? "Unknown User";
                            final alat = p?['alat']?['nama_alat'] ?? "Alat Dihapus";

                            return _buildReturnCard(
                              context,
                              id: item['id_pengembalian'].toString(),
                              name: user,
                              tool: alat,
                              date: item['tanggal_kembali'],
                              status: item['kondisi_saat_dikembalikan'],
                              statusColor: item['kondisi_saat_dikembalikan'] == "Baik"
                                  ? Colors.green
                                  : Colors.orange,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 2,
        onItemTapped: (index) {},
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3B6790),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const BuatPengembalianDialog(),
          );
          if (result == true) setState(() {});
        },
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildReturnCard(
    BuildContext context, {
    required String id,
    required String name,
    required String tool,
    required String date,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE7F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  id,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B6790),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      tool,
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoCol("TANGGAL", date),
              _buildInfoCol("STATUS", status, color: statusColor),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPengembalianPage(
                          id: id,
                          name: name,
                          tool: tool,
                          date: date,
                          condition: status,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEEEEEE),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    "LIHAT DETAIL",
                    style: GoogleFonts.poppins(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () => _confirmDelete(context, id),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCol(String label, String value, {Color color = Colors.black}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}