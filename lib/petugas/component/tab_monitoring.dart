import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/petugas/component/header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class TabMonitoring extends StatefulWidget {
  final String userName;
  const TabMonitoring({super.key, required this.userName});

  @override
  State<TabMonitoring> createState() => _TabMonitoringState();
}

class _TabMonitoringState extends State<TabMonitoring> {
  String _searchQuery = "";
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeaderPetugas(
          context,
          widget.userName,
          onSearch: (val) {
            setState(() {
              _searchQuery = val.toLowerCase();
            });
          },
        ),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: supabase
                .from('peminjaman')
                .stream(primaryKey: ['id_peminjaman'])
                .eq('status', 'disetujui')
                .order('batas_pengembalian', ascending: true),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data ?? [];
              final filteredData = data.where((item) {
                return item['id_peminjaman'].toString().contains(_searchQuery);
              }).toList();

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildStatCards(data),
                  const SizedBox(height: 25),
                  Text(
                    "Daftar Pinjaman Aktif",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF1A314D),
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (filteredData.isEmpty)
                    _buildEmptyState()
                  else
                    ...filteredData.map((item) => _buildAsyncCard(context, item)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards(List<Map<String, dynamic>> data) {
    int dipinjam = data.length;
    int terlambat = data.where((e) {
      final deadline = DateTime.parse(e['batas_pengembalian']);
      return deadline.isBefore(DateTime.now());
    }).length;

    return Row(
      children: [
        _statItem(dipinjam.toString(), "DIPINJAM", Icons.assignment_returned, Colors.blue),
        const SizedBox(width: 15),
        _statItem(terlambat.toString(), "TERLAMBAT", Icons.history_toggle_off, Colors.orange),
      ],
    );
  }

  Widget _statItem(String val, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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

  Widget _buildAsyncCard(BuildContext context, Map<String, dynamic> item) {
    return FutureBuilder(
      future: Future.wait([
        supabase.from('users').select('username').eq('id_user', item['id_user']).single(),
        supabase.from('alat').select('nama_alat').eq('id_alat', item['id_alat']).single(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
          );
        }

        final String namaUser = snapshot.data![0]['username'] ?? "User";
        final String namaAlat = snapshot.data![1]['nama_alat'] ?? "Alat";
        DateTime deadline = DateTime.parse(item['batas_pengembalian']);
        bool isLate = deadline.isBefore(DateTime.now());

        int hariTerlambat = isLate ? DateTime.now().difference(deadline).inDays : 0;
        int estimasiDenda = hariTerlambat * 5000;

        return _cardMonitoring(context, namaAlat, "#ID-${item['id_peminjaman']}", namaUser, item['batas_pengembalian'], isLate, item['id_peminjaman'], estimasiDenda);
      },
    );
  }

  Widget _cardMonitoring(BuildContext context, String alat, String id, String nama, String tgl, bool isTerlambat, int idPeminjaman, int denda) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: isTerlambat ? const Color(0xFFFFFBFA) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isTerlambat ? Colors.red.shade100 : Colors.black12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(alat, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16))),
                if (isTerlambat)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                    child: Text("Rp ${NumberFormat('#,###').format(denda)}", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            Text(id, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 15),
            Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: const Color(0xFF1A314D).withOpacity(0.1), child: const Icon(Icons.person, size: 12, color: Color(0xFF1A314D))),
                const SizedBox(width: 8),
                Text(nama, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Batas Kembali:", style: TextStyle(fontSize: 9, color: Colors.grey)),
                    Text(DateFormat('dd MMMM yyyy').format(DateTime.parse(tgl)), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isTerlambat ? Colors.red : Colors.black)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _showConfirmationDialog(context, idPeminjaman),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A314D), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text("KEMBALIKAN", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- FUNGSI TAMPIL DIALOG (MENCEGAH ERROR DIRECT CALL) ---
  void _showConfirmationDialog(BuildContext context, int id) async {
    try {
      final dataPeminjaman = await supabase.from('peminjaman').select('batas_pengembalian').eq('id_peminjaman', id).single();
      final DateTime batasTgl = DateTime.parse(dataPeminjaman['batas_pengembalian']);
      final DateTime sekarang = DateTime.now();

      final dendaAuto = await supabase.rpc('hitung_denda', params: {
        'p_batas': batasTgl.toIso8601String(),
        'p_kembali': sekarang.toIso8601String(),
      });

      final TextEditingController dendaController = TextEditingController(text: dendaAuto.toString());

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Konfirmasi Kembali", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sesuaikan nominal denda jika diperlukan:", style: TextStyle(fontSize: 13)),
              const SizedBox(height: 15),
              TextField(
                controller: dendaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Nominal Denda (Rp)",
                  prefixText: "Rp ",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A314D)),
              onPressed: () {
                int dendaFinal = int.tryParse(dendaController.text) ?? 0;
                Navigator.pop(context);
                _prosesKembali(context, id, dendaFinal);
              },
              child: const Text("Proses", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memuat denda: $e"), backgroundColor: Colors.red));
      }
    }
  }

  // --- LOGIKA UPDATE DATABASE ---
  void _prosesKembali(BuildContext context, int id, int dendaFinal) async {
    final user = supabase.auth.currentUser;
    final DateTime sekarang = DateTime.now();

    try {
      final dataPeminjaman = await supabase.from('peminjaman').select('id_alat, jumlah').eq('id_peminjaman', id).single();

      await Future.wait([
        supabase.from('peminjaman').update({
          'status': 'dikembalikan',
          'updated_at': sekarang.toIso8601String()
        }).eq('id_peminjaman', id),
        supabase.from('pengembalian').insert({
          'id_peminjaman': id,
          'tanggal_kembali': sekarang.toIso8601String(),
          'kondisi_saat_dikembalikan': 'baik',
          'catatan': dendaFinal > 0 ? 'Terlambat' : 'Tepat waktu',
          'denda': dendaFinal,
          'diterima_oleh': user?.id,
        }),
        _updateStokAlat(dataPeminjaman['id_alat'], dataPeminjaman['jumlah']),
      ]);

      if (context.mounted) _showSuccessSheet(context, dendaFinal);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal proses: $e"), backgroundColor: Colors.red));
      }
    }
  }

  // --- UPDATE STOK ALAT ---
  Future<void> _updateStokAlat(int idAlat, int jumlah) async {
    final res = await supabase.from('alat').select('stok_alat').eq('id_alat', idAlat).single();
    int stokSekarang = res['stok_alat'] as int;
    await supabase.from('alat').update({
      'stok_alat': stokSekarang + jumlah
    }).eq('id_alat', idAlat);
  }

  void _showSuccessSheet(BuildContext context, int denda) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(denda > 0 ? Icons.warning_amber_rounded : Icons.check_circle_outline, size: 80, color: denda > 0 ? Colors.orange : Colors.green),
              const SizedBox(height: 15),
              Text(denda > 0 ? "Terlambat!" : "Berhasil!", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(denda > 0 ? "Denda: Rp ${NumberFormat('#,###').format(denda)}" : "Alat telah kembali dan stok diperbarui.", textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.grey)),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A314D), padding: const EdgeInsets.all(15)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("SELESAI", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(Icons.verified_outlined, size: 70, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          Text("Semua alat sudah kembali", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}