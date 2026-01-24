import 'package:flutter/material.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/user/menu_item_card.dart';
import 'package:inventory_alat/admin/screen/user_management_page.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

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
                    "Sistem Data",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  MenuItemCard(
                    title: "User & Siswa",
                    subtitle: "Kelola akun dan data siswa",
                    icon: Icons.people_outline_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserManagementPage(),
                        ),
                      );
                    },
                  ),
                  MenuItemCard(
                    title: "Alat Praktikum",
                    subtitle: "Inventaris alat bengkel",
                    icon: Icons.build_outlined,
                    onTap: () {},
                  ),
                  MenuItemCard(
                    title: "Kategoti Alat",
                    subtitle: "Pengelompokan jenis alat",
                    icon: Icons.local_offer_outlined,
                    onTap: () {},
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
