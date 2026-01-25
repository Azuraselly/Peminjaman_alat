import 'package:flutter/material.dart';
import 'package:inventory_alat/colors.dart';

class CustomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  

  const CustomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 106,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.seli,
          unselectedItemColor: AppColors.abuh,
          // Gunakan variabel dari parameter
          currentIndex: selectedIndex, 
          onTap: onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "Beranda"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: "Admin"),
            BottomNavigationBarItem(icon: Icon(Icons.swap_horiz_rounded), label: "Transaksi"),
            BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: "Riwayat"),
          ],
        ),
      ),
    );
  }
}