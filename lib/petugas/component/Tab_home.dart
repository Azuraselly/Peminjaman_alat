import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/petugas/component/header.dart';

class HomeApprovalTab extends StatelessWidget {
  const HomeApprovalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeaderPetugas("Home"),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildStatCards(),
              const SizedBox(height: 20),
              Text("Butuh Persetujuan", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              _buildApprovalCard("Azura", "XII TKR 1", "Dongkrak", "18 JAN 2026"),
              _buildApprovalCard("Budi", "XII TKR 2", "Kunci Momen", "18 JAN 2026"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        _statItem("3", "DIPINJAM", Icons.assignment_turned_in, Colors.blue),
        const SizedBox(width: 15),
        _statItem("1", "TERLAMBAT", Icons.error_outline, Colors.red),
      ],
    );
  }

  Widget _statItem(String val, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: color, size: 20), const SizedBox(width: 8), Text(val, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20))]),
            Text(label, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalCard(String nama, String kelas, String alat, String tgl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black12)),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.blue.shade50, child: const Text("AZ", style: TextStyle(fontSize: 12))),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)), Text(kelas, style: const TextStyle(fontSize: 11, color: Colors.grey))]),
              const Spacer(),
              Text(tgl, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF1F4F8), borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                const Icon(Icons.build_outlined, size: 20, color: Color(0xFF1A314D)),
                const SizedBox(width: 10),
                Text(alat, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () {}, child: const Text("Tolak"))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A76A8)), child: const Text("Setujui", style: TextStyle(color: Colors.white)))),
            ],
          )
        ],
      ),
    );
  }
}