import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  // Tambahkan parameter ini
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
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF162D4A),
          unselectedItemColor: Colors.grey,
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