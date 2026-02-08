import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/service/peminjaman_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilPeminjam extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfilPeminjam({super.key, required this.onLogout});

  @override
  State<ProfilPeminjam> createState() => _ProfilPeminjamState();
}

class _ProfilPeminjamState extends State<ProfilPeminjam> {
  final _service = PeminjamanService();
  final _supabase = Supabase.instance.client;
  
  String? _username;
  String? _class;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _service.getUserProfile();
      setState(() {
        _username = profile?['username'] ?? 'Nama Pengguna';
        _class = profile?['class'] ?? 'Kelas';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) => Container(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('Konfirmasi Keluar', 
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              content: Text('Apakah Anda yakin ingin mengakhiri sesi ini?', 
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins()),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Batal', style: GoogleFonts.poppins(color: Colors.black87)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Keluar', style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirm == true) {
      try {
        await _supabase.auth.signOut();
        widget.onLogout(); 
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal keluar: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER SECTION
            _buildHeader(),
            
            const SizedBox(height: 50),
            
            // USER INFO CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    _buildInfoTile(Icons.person_rounded, "Nama Lengkap", _username ?? '-'),
                    const Divider(height: 30, thickness: 0.5),
                    _buildInfoTile(Icons.school_rounded, "Kelas / Jabatan", _class ?? '-'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  label: Text("Keluar dari Akun", 
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white
                    )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A314D),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                    shadowColor: const Color(0xFF1A314D).withOpacity(0.3),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            Text("Versi 1.0.0", 
              style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 240,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A314D), Color(0xFF2C5384)],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Profil Peminjam",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: const Color(0xFFE9EEF5),
              child: Icon(Icons.person_rounded, 
                size: 65, 
                color: const Color(0xFF1A314D).withOpacity(0.8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF1A314D), size: 24),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
            Text(value, 
              style: GoogleFonts.poppins(
                fontSize: 16, 
                fontWeight: FontWeight.w600,
                color: Colors.black87
              )),
          ],
        )
      ],
    );
  }
}