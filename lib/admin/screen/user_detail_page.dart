import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text("Detail User", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(25),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar Box
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(color: const Color(0xFFE8EEF5), borderRadius: BorderRadius.circular(20)),
                child: const Text("AZ", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF3B71B9))),
              ),
              const SizedBox(height: 20),
              const Text("Azura", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFFE8EEF5), borderRadius: BorderRadius.circular(10)),
                child: const Text("SISWA", style: TextStyle(color: Color(0xFF3B71B9), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _detailItem("KELAS", "XII TKR 1"),
                  _detailItem("STATUS AKUN", "Aktif", valColor: Colors.green),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(15)),
                child: const Row(
                  children: [
                    Icon(Icons.swap_horiz, color: Colors.grey),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TOTAL PINJAM", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        Text("12 Kali", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEEEEEE),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("EDIT DATA"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _actionIcon(Icons.delete_outline, Colors.red),
                ],
              )
            ],
          ),
        ),
      ),
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

  Widget _actionIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: color, size: 20),
    );
  }
}