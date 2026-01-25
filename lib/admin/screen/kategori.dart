import 'package:flutter/material.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/kategori/add_kategori.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/kategori/add_kategori.dart';
import 'package:inventory_alat/admin/component/kategori/kategori_card.dart';
import 'package:inventory_alat/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/screen/detail_kategori.dart';

class Kategori extends StatefulWidget {
  const Kategori({super.key});

  @override
  State<Kategori> createState() => _KategoriState();
  
}

class _KategoriState extends State<Kategori> {
  bool _showNotification = false;
    int _currentIndex = 0;
    

  void _triggerNotification() {
    setState(() => _showNotification = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showNotification = false);
    });
  }

  void _showDeleteConfirmation(String name) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Konfirmasi Hapus",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("Yakin ingin menghapus $name?", textAlign: TextAlign.center),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Batal",
                      style: GoogleFonts.poppins(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _triggerNotification();
                    },
                    child: Text(
                      "Hapus",
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
       bottomNavigationBar: CustomNavbar(
        selectedIndex: _currentIndex,
        onItemTapped: (index) {
          setState(() {
            _currentIndex = index; // Ganti halaman saat diklik
          });
        },
      ),
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
                      () {
                        showDialog(
                          context: context,
                          builder: (_) => AddKategori(onSaveSuccess: (String name) {   },),
                        );
                      },
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
                          hintStyle: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.abumud,),
                          prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.abumud),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.abumud, width: 1),
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
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  children: [
                    KategoriCard(
                      name: "Alat Tangan",
                      deskripsi: "Membantu...",
                      jumlah: "5 Unit",
                      onDelete: () => _showDeleteConfirmation("Tang Kombinasi"),
                      onTapDetail: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailKategoriPage())),
                    ),
                    KategoriCard(
                      name: "Servis",
                      deskripsi: "Membantu...",
                      jumlah: "8 Unit",
                      onDelete: () => _showDeleteConfirmation("Dongkrak Buaya"),
                      onTapDetail: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailKategoriPage())),
                    ),
                    KategoriCard(
                      name: "K3",
                      deskripsi: "Membantu...",
                      jumlah: "2 Unit",
                      onDelete: () => _showDeleteConfirmation("Kunci Momen"),
                      onTapDetail: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailKategoriPage())),
                    ),
                  ],
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
                  child:  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 15),
                      Text(
                        "Berhasil menghapus 1 user",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
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
