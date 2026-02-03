import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/petugas/component/header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TabHomePetugas extends StatelessWidget {
  final String userName;
  const TabHomePetugas({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Column(
      children: [
        buildHeaderPetugas(userName),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            // 1. Ganti primaryKey ke 'id_peminjaman'
            // 2. Ganti filter status ke 'diajukan' sesuai skema SQL
            stream: supabase
                .from('peminjaman')
                .stream(primaryKey: ['id_peminjaman'])
                .eq('status', 'diajukan'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data ?? [];

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildStatCards(supabase),
                  const SizedBox(height: 20),
                  Text(
                    "Butuh Persetujuan",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (data.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text("Tidak ada permintaan (diajukan)"),
                      ),
                    ),
                  ...data
                      .map((item) => _buildApprovalCard(context, item))
                      .toList(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: const Icon(Icons.person, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mengambil ID User karena nama ada di tabel berbeda
                  Text(
                    "Peminjam: ${item['users']?['username'] ?? 'Tidak diketahui'}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(
                    "Kelas: ${item['tingkatan_kelas'] ?? "-"}",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                item['tanggal_pinjam'] ?? "-",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.build_outlined,
                  size: 20,
                  color: Color(0xFF1A314D),
                ),
                const SizedBox(width: 10),
                // Menampilkan ID Alat (untuk nama alat perlu logic fetch tambahan atau join)
                Text(
                  "Alat ID: ${item['id_alat']}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text("Qty: ${item['jumlah'] ?? 0}"),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      _updateStatus(item['id_peminjaman'], 'ditolak'),
                  child: const Text("Tolak"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      _updateStatus(item['id_peminjaman'], 'disetujui'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A76A8),
                  ),
                  child: const Text(
                    "Setujui",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fungsi update status sesuai dengan value di skema SQL
  void _updateStatus(dynamic idpeminjaman, String status) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    await supabase
        .from('peminjaman')
        .update({
          'status': status,
          'disetujui_oleh': user?.id, // Mencatat petugas yang menyetujui
          'waktu_setujui': DateTime.now().toIso8601String(),
        })
        .eq('id_peminjaman', idpeminjaman);
  }

  Widget _buildStatCards(SupabaseClient supabase) {
    return FutureBuilder(
      // Menghitung statistik secara dinamis dari database
      future: supabase.from('peminjaman').select('status'),
      builder: (context, snapshot) {
        int dipinjam = 0;
        if (snapshot.hasData) {
          dipinjam = (snapshot.data as List)
              .where((e) => e['status'] == 'disetujui')
              .length;
        }
        return Row(
          children: [
            _statItem(
              dipinjam.toString(),
              "DIPINJAM",
              Icons.assignment_turned_in,
              Colors.blue,
            ),
            const SizedBox(width: 15),
            _statItem("0", "TERLAMBAT", Icons.error_outline, Colors.red),
          ],
        );
      },
    );
  }

  Widget _statItem(String val, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  val,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
