import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/petugas/component/header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class TabLaporan extends StatefulWidget {
  final String userName;
  const TabLaporan({super.key, required this.userName});

  @override
  State<TabLaporan> createState() => _TabLaporanState();
}

class _TabLaporanState extends State<TabLaporan> {
  String _searchQuery = "";
  final supabase = Supabase.instance.client;

  // Stream data untuk statistik real-time
  Stream<List<Map<String, dynamic>>> _getPeminjamanStream() {
    return supabase
        .from('peminjaman')
        .stream(primaryKey: ['id_peminjaman'])
        .order('created_at', ascending: false);
  }

  // --- FUNGSI POP-UP PENGECEKAN KONDISI & DENDA ---
  void _showReturnDialog(Map<String, dynamic> item) {
    String selectedKondisi = 'baik';
    final TextEditingController dendaController = TextEditingController(text: '0');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("Pengecekan Alat", 
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Alat: ${item['alat']?['nama_alat'] ?? 'Alat'}", 
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  const Text("Pilih Kondisi Akhir:", style: TextStyle(fontSize: 12)),
                  
                  DropdownButton<String>(
                    isExpanded: true,
                    value: selectedKondisi,
                    items: ['baik', 'rusak ringan', 'rusak berat', 'hilang'].map((val) {
                      return DropdownMenuItem(value: val, child: Text(val.toUpperCase()));
                    }).toList(),
                    onChanged: (val) {
                      setModalState(() {
                        selectedKondisi = val!;
                        // Logic Denda Otomatis (Bisa disesuaikan)
                        if (val == 'rusak ringan') dendaController.text = '20000';
                        else if (val == 'rusak berat') dendaController.text = '50000';
                        else if (val == 'hilang') dendaController.text = '150000';
                        else dendaController.text = '0';
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text("Nominal Denda (Rp):", style: TextStyle(fontSize: 12)),
                  TextField(
                    controller: dendaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "0",
                      prefixText: "Rp ",
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A314D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  _processReturn(
                    item['id_peminjaman'], 
                    item['id_alat'], 
                    item['jumlah'],
                    selectedKondisi, 
                    int.tryParse(dendaController.text) ?? 0
                  );
                },
                child: const Text("Selesaikan", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- LOGIKA UPDATE DATABASE ---
  Future<void> _processReturn(int idPinjam, int idAlat, int jml, String kondisi, int denda) async {
    try {
      // 1. Update Tabel Peminjaman dengan data denda & kondisi
      await supabase.from('peminjaman').update({
        'status': 'dikembalikan',
        'kondisi_kembali': kondisi,
        'denda': denda,
        'tanggal_kembali': DateTime.now().toIso8601String(),
      }).eq('id_peminjaman', idPinjam);

      // 2. Update Stok Alat (Kecuali jika hilang)
      if (kondisi != 'hilang') {
        final res = await supabase.from('alat').select('stok_alat').eq('id_alat', idAlat).single();
        await supabase.from('alat').update({
          'stok_alat': (res['stok_alat'] as int) + jml
        }).eq('id_alat', idAlat);
      }

      if (mounted) {
        Navigator.pop(context); // Tutup Dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Berhasil! Denda Rp $denda tercatat di riwayat peminjam."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHeaderPetugas(
          context,
          widget.userName,
          onSearch: (val) => setState(() => _searchQuery = val.toLowerCase()),
        ),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _getPeminjamanStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final allData = snapshot.data ?? [];
              
              // Filter Statistik
              int aktif = allData.where((e) => e['status'] == 'disetujui').length;
              int kembali = allData.where((e) => e['status'] == 'dikembalikan').length;
              int diajukan = allData.where((e) => e['status'] == 'diajukan').length;

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text("Ringkasan Operasional", 
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: const Color(0xFF1A314D))),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _statCard("Proses", diajukan.toString(), Colors.blue, Icons.hourglass_empty),
                      const SizedBox(width: 12),
                      _statCard("Dipinjam", aktif.toString(), Colors.orange, Icons.swap_horiz_rounded),
                      const SizedBox(width: 12),
                      _statCard("Selesai", kembali.toString(), Colors.green, Icons.check_circle),
                    ],
                  ),
                  const SizedBox(height: 25),
                  _buildVisualProgress(kembali, allData.length),
                  const SizedBox(height: 30),
                  Text("Log Transaksi", 
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 15),
                  _buildDetailedList(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualProgress(int kembali, int total) {
    double persen = total == 0 ? 0 : kembali / total;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1A314D), Color(0xFF2C5382)]),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Penyelesaian Tugas", style: TextStyle(color: Colors.white)),
              Text("${(persen * 100).toInt()}%", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: persen,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation(Colors.greenAccent),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

 Widget _buildDetailedList() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: supabase.from('peminjaman').select('*, users:id_user(username), alat:id_alat(nama_alat)').order('created_at', ascending: false),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return const SizedBox();
      
      final list = snapshot.data!.where((item) {
        final alat = item['alat']?['nama_alat']?.toString().toLowerCase() ?? "";
        return alat.contains(_searchQuery);
      }).toList();

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          final status = item['status'];
          final hasDenda = (item['denda'] ?? 0) > 0;
          
          // --- LOGIKA TERLAMBAT ---
          final DateTime deadline = DateTime.parse(item['batas_pengembalian']);
          final bool isLate = status == 'disetujui' && deadline.isBefore(DateTime.now());
          final Color themeColor = _getStatusColor(status, isLate);

          return GestureDetector(
            onTap: () {
              if (status == 'disetujui') _showReturnDialog(item);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                // Bingkai menjadi merah jika terlambat
                border: Border.all(
                  color: isLate ? Colors.red.shade300 : (status == 'disetujui' ? Colors.orange.shade100 : Colors.transparent),
                  width: isLate ? 1.5 : 1,
                ),
                boxShadow: [
                  if (isLate) BoxShadow(color: Colors.red.withOpacity(0.05), blurRadius: 5, spreadRadius: 1)
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: themeColor.withOpacity(0.1),
                    child: Icon(
                      isLate ? Icons.priority_high : Icons.inventory_2, 
                      color: themeColor, 
                      size: 18
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['alat']?['nama_alat'] ?? 'Alat', 
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("User: ${item['users']?['username']}", 
                          style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        if (isLate)
                          const Text("⚠️ TERLAMBAT", 
                            style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
                        if (status == 'dikembalikan') 
                          Text("Kondisi: ${item['kondisi_kembali'] ?? 'baik'}", 
                            style: TextStyle(fontSize: 10, color: Colors.blue.shade700)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isLate ? "TERLAMBAT" : status.toString().toUpperCase(), 
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: themeColor)
                      ),
                      if (hasDenda)
                        Text("Denda: Rp${item['denda']}", 
                          style: const TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
                      Text(DateFormat('dd/MM').format(DateTime.parse(item['created_at'])), 
                        style: const TextStyle(fontSize: 9, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

 Color _getStatusColor(String status, bool isLate) {
  if (isLate && status == 'disetujui') return Colors.red; 
  switch (status) {
    case 'disetujui': return Colors.orange;
    case 'dikembalikan': return Colors.green;
    case 'diajukan': return Colors.blue;
    default: return Colors.grey;
  }
}
}