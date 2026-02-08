import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/petugas/component/header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TabHomePetugas extends StatefulWidget {
  final String userName;
  const TabHomePetugas({super.key, required this.userName});

  @override
  State<TabHomePetugas> createState() => _TabHomePetugasState();
}

class _TabHomePetugasState extends State<TabHomePetugas> {
  String _searchQuery = "";
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header dengan fungsi search
        buildHeaderPetugas(context, widget.userName, onSearch: (val) {
          setState(() {
            _searchQuery = val.toLowerCase();
          });
        }),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
          
            // Begitu status di database berubah, baris ini otomatis dibuang dari list stream
            stream: supabase
                .from('peminjaman')
                .stream(primaryKey: ['id_peminjaman'])
                .eq('status', 'diajukan')
                .order('tanggal_pinjam', ascending: false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final data = snapshot.data ?? [];

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildStatCards(supabase),
                  const SizedBox(height: 25),
                  Text(
                    "Butuh Persetujuan",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF1A314D),
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (data.isEmpty)
                    _buildEmptyState()
                  else
                    // Menggunakan Key agar Flutter tahu kartu mana yang hilang
                    ...data.map((item) => _buildApprovalCard(
                          context, 
                          item, 
                          key: ValueKey(item['id_peminjaman']),
                        )),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalCard(BuildContext context, Map<String, dynamic> item, {Key? key}) {
    final supabase = Supabase.instance.client;

    return FutureBuilder(
      key: key, // Memberikan key unik agar tidak tertukar saat proses rebuild
      future: Future.wait([
        supabase.from('users').select('username, class').eq('id_user', item['id_user']).single(),
        supabase.from('alat').select('nama_alat').eq('id_alat', item['id_alat']).single(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> detailSnapshot) {
        if (!detailSnapshot.hasData) {
          return const SizedBox.shrink(); // Sembunyikan jika data detail belum siap
        }

        final userData = detailSnapshot.data![0];
        final alatData = detailSnapshot.data![1];

        final String namaPeminjam = userData['username'] ?? "Unknown";
        final String userClass = (userData['class']?.toString() ?? "-");
        final String namaAlat = alatData['nama_alat'] ?? "Alat Dihapus";
        final String jumlahUnit = item['jumlah']?.toString() ?? "0";

        return Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF4A76A8).withOpacity(0.1),
                    child: const Icon(Icons.person, color: Color(0xFF4A76A8)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(namaPeminjam, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
                        Text("Kelas $userClass", style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF4A76A8))),
                      ],
                    ),
                  ),
                  Text(item['tanggal_pinjam'] ?? "-", style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                ],
              ),
              const Divider(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(namaAlat, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text("$jumlahUnit Unit", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _actionButton(context, item['id_peminjaman'], 'ditolak', Colors.redAccent, "Tolak"),
                  const SizedBox(width: 10),
                  _actionButton(context, item['id_peminjaman'], 'disetujui', const Color(0xFF4A76A8), "Setujui"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _actionButton(BuildContext context, dynamic id, String status, Color color, String label) {
    return Expanded(
      child: status == 'ditolak'
          ? OutlinedButton(
              onPressed: () => _updateStatus(context, id, status),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: color),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(label, style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w600)),
            )
          : ElevatedButton(
              onPressed: () => _updateStatus(context, id, status),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(label, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
    );
  }

  void _updateStatus(BuildContext context, dynamic idpeminjaman, String status) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    try {
      // PROSES UPDATE: Status berubah di DB -> Stream mendeteksi -> Kartu otomatis hilang
      await supabase.from('peminjaman').update({
        'status': status,
        'disetujui_oleh': user?.id,
        'waktu_setujui': DateTime.now().toIso8601String(),
      }).eq('id_peminjaman', idpeminjaman);

      if (context.mounted) {
        _showModernSnackBar(context, status == 'disetujui');
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    }
  }

  void _showModernSnackBar(BuildContext context, bool isApprove) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isApprove ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Icon(isApprove ? Icons.check_circle : Icons.cancel, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isApprove ? "Berhasil Disetujui" : "Permintaan Ditolak",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("Berhasil disetujui petugas",
                        style: GoogleFonts.poppins(fontSize: 11, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Statistik tetap Real-time mengikuti jumlah data terbaru
  Widget _buildStatCards(SupabaseClient supabase) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase.from('peminjaman').stream(primaryKey: ['id_peminjaman']),
      builder: (context, snapshot) {
        int dipinjam = 0;
        int terlambat = 0;
        if (snapshot.hasData) {
          final allData = snapshot.data!;
          dipinjam = allData.where((e) => e['status'] == 'disetujui').length;
          terlambat = allData.where((e) {
            if (e['status'] != 'disetujui' || e['batas_pengembalian'] == null) return false;
            return DateTime.parse(e['batas_pengembalian']).isBefore(DateTime.now());
          }).length;
        }
        return Row(
          children: [
            _statItem(dipinjam.toString(), "DIPINJAM", Icons.assignment_turned_in, Colors.blue),
            const SizedBox(width: 15),
            _statItem(terlambat.toString(), "TERLAMBAT", Icons.history_toggle_off, Colors.orange),
          ],
        );
      },
    );
  }

  Widget _statItem(String val, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(val, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24)),
            Text(label, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Icon(Icons.auto_awesome_motion_rounded, size: 80, color: Colors.grey.shade200),
          const SizedBox(height: 15),
          Text("Semua permintaan sudah diproses",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}