import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/navbar.dart';

class UserDetailPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const UserDetailPage({super.key, required this.userData});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {

  @override
  Widget build(BuildContext context) {
    final user = widget.userData;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomHeader(), // Header muncul di detail
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        style: IconButton.styleFrom(backgroundColor: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Text("Profil User", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: const Color(0xFFE8EEF5),
                          child: Text((user['username'] ?? '?').substring(0, 1).toUpperCase(), 
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF3B71B9))),
                        ),
                        const SizedBox(height: 20),
                        Text(user['username'] ?? 'Unknown User', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        _buildTag((user['role'] ?? 'USER').toUpperCase()),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _detailItem("KELAS", user['kelas'] ?? '-'),
                            _detailItem("STATUS AKUN", user['status'] == true ? 'Aktif' : 'Nonaktif', 
                              valColor: user['status'] == true ? Colors.green : Colors.red),
                          ],
                        ),
                        const SizedBox(height: 30),
                        _actionButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
       bottomNavigationBar: CustomNavbar(
        selectedIndex: 1,
        onItemTapped: (index) {
          Navigator.pop(context); 
        },
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: const Color(0xFFE8EEF5), borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: const TextStyle(color: Color(0xFF3B71B9), fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _detailItem(String label, String value, {Color valColor = Colors.black}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valColor)),
      ],
    );
  }

  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {}, // Fungsi Edit
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF1F4F8),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("EDIT DATA"),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.delete_outline, color: Colors.red),
        )
      ],
    );
  }
}