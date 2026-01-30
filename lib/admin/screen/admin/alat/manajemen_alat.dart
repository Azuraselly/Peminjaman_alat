import 'package:flutter/material.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/alat/add_alat.dart';
import 'package:inventory_alat/admin/component/alat/alat_card.dart';
import 'package:inventory_alat/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ManajemenAlatPage extends StatefulWidget {
  const ManajemenAlatPage({super.key});

  @override
  State<ManajemenAlatPage> createState() => _ManajemenAlatPageState();
}

class _ManajemenAlatPageState extends State<ManajemenAlatPage> {
  bool _showNotification = false;
  String _notifMessage = "";

  List<Map<String, dynamic>> _allAlat = [
    {
      "name": "Tang Kombinasi",
      "kategori": "ALAT TANGAN",
      "stok": "5 Unit",
      "kondisi": "Baik",
      "desc": "Tang serbaguna",
    },
    {
      "name": "Dongkrak Buaya",
      "kategori": "SERVIS",
      "stok": "8 Unit",
      "kondisi": "Rusak Ringan",
      "desc": "Dongkrak hidrolik",
    },
  ];

void _openForm({Map<String, dynamic>? item, int? index}) {
    showDialog(
      context: context,
      builder: (_) => AddAlat(
        initialData: item,
        onSaveSuccess: (newData) {
          setState(() {
            if (index != null) {
              _allAlat[index] = newData;
              _notifMessage = "Berhasil memperbarui ${newData['name']}";
            } else {
              _allAlat.add(newData);
              _notifMessage = "Berhasil menambah ${newData['name']}";
            }
          });
          _triggerNotification(_notifMessage); // Kirim pesan ke notif
        },
      ),
    );
  }

  void _triggerNotification(String message) {
    setState(() {
      _notifMessage = message; // Update pesan yang akan muncul di snackbar/overlay
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
                      _triggerNotification(name);
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

  void _deleteAlat(int index) {
    String deletedName = _allAlat[index]['name'];
    setState(() {
      _allAlat.removeAt(index);
      _notifMessage = "Berhasil menghapus $deletedName";
    });
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
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  itemCount: _allAlat.length,
                  itemBuilder: (context, index) {
                    final item = _allAlat[index];
                    return AlatCard(
                      name: item['name'],
                      kategoriName: item['kategori'],
                      stok: item['stok'],
                      kondisi: item['kondisi'],
                      onDelete: () {
                        _showDeleteConfirmation(item['name']);
                        _deleteAlat(index);
                      }, // Panggil konfirmasi hapus
                      onTapDetail: () => _openForm(
                        item: item,
                        index: index,
                      ), // Sekarang Tap Detail berfungsi sebagai Edit
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
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Admin 01",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _notifMessage,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.black87,
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
