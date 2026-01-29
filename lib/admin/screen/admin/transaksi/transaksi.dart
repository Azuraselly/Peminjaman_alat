import 'package:flutter/material.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/user/menu_item_card.dart';
import 'package:inventory_alat/admin/screen/admin/alat/manajemen_alat.dart';
import 'package:inventory_alat/admin/screen/admin/transaksi/peminjaman.dart';
import 'package:inventory_alat/admin/screen/admin/user/user_management_page.dart';

class Transaksi extends StatelessWidget {
  const Transaksi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TRANSAKSI",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  MenuItemCard(
                    title: "Peminjaman Alat",
                    subtitle: "Catatan alat yang keluar",
                    icon:  Icons.swap_horiz_rounded,
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DataPeminjamanPage(),
                        ),
                      );
                    },
                  ),
                  MenuItemCard(
                    title: "Pengembalian Alat",
                    subtitle: "Verifikasi alat kembali",
                    icon: Icons.tag_outlined,
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManajemenAlatPage(),
                        ),
                      );
                    },
                  ),
              
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
