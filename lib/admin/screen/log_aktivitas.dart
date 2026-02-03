import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/models/log_aktivitas.dart';

import 'package:inventory_alat/service/peminjaman_service.dart'; 

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final PeminjamanService _service = PeminjamanService();
  List<LogAktivitas> logList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogData();
  }

  Future<void> _loadLogData() async {
  if (!mounted) return; // Tambahkan ini
  setState(() => isLoading = true);
  
  try {
    final data = await _service.getLogs();
    
    if (mounted) { // Tambahkan ini
      setState(() {
        logList = data;
        isLoading = false;
      });
    }
  } catch (e) {
    if (mounted) setState(() => isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: RefreshIndicator(
        onRefresh: _loadLogData,
        child: CustomScrollView( // Menggunakan CustomScrollView agar RefreshIndicator berfungsi maksimal
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Log Aktivitas",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    if (!isLoading)
                      Text(
                        "${logList.length} aktivitas",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (logList.isEmpty)
              SliverFillRemaining(
                child: _buildEmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildLogCard(logList[index]),
                    childCount: logList.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.history, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text(
          "Belum ada aktivitas",
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLogCard(LogAktivitas log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Indicator berdasarkan tipe aksi
          _buildActionIcon(log.aksi),
          const SizedBox(width: 15),
          
          // Informasi Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        log.user?.username ?? 'System',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: const Color(0xFF1A1A1A),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      log.getTimeAgo(),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // AKSI yang dilakukan diletakkan di bawah Nama
                Text(
                  log.aksi,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blueGrey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // Badge Role di bagian bawah untuk kerapihan
                _buildRoleSmallBadge(log.user?.role),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Icon di sebelah kiri untuk membedakan jenis aktivitas secara visual
  Widget _buildActionIcon(String aksi) {
    IconData iconData = Icons.info_outline;
    Color color = Colors.grey;

    if (aksi.toLowerCase().contains("tambah")) {
      iconData = Icons.add_circle_outline;
      color = Colors.green;
    } else if (aksi.toLowerCase().contains("hapus")) {
      iconData = Icons.delete_outline;
      color = Colors.red;
    } else if (aksi.toLowerCase().contains("setuju") || aksi.toLowerCase().contains("kembali")) {
      iconData = Icons.check_circle_outline;
      color = Colors.blue;
    } else if (aksi.toLowerCase().contains("edit") || aksi.toLowerCase().contains("ubah")) {
      iconData = Icons.edit_note;
      color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color, size: 20),
    );
  }

  // Badge Role yang lebih ringkas di bawah aksi
  Widget _buildRoleSmallBadge(UserRole? role) {
    String roleName = role?.toString().split('.').last.toUpperCase() ?? 'SYSTEM';
    Color color = _getRoleColor(role);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        roleName,
        style: GoogleFonts.poppins(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
  Color _getRoleColor(UserRole? role) {
    switch (role) {
      case UserRole.admin: return Colors.redAccent;
      case UserRole.petugas: return Colors.blueAccent;
      case UserRole.peminjam: return Colors.greenAccent;
      default: return Colors.grey;
    }
  }

  IconData _getRoleIcon(UserRole? role) {
    switch (role) {
      case UserRole.admin: return Icons.admin_panel_settings;
      case UserRole.petugas: return Icons.engineering;
      case UserRole.peminjam: return Icons.person;
      default: return Icons.info_outline;
    }
  }
}