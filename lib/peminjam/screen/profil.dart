import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/service/peminjaman_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilPeminjam extends StatefulWidget {
  const ProfilPeminjam({super.key});

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
        _username = profile?['username'] ?? 'Peminjam';
        _class = profile?['class'] ?? '-';
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profile: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Konfirmasi Keluar',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Keluar', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _supabase.auth.signOut();
        // Navigate to login page
        // You need to implement navigation to your login page
        if (mounted) {
          // Navigator.of(context).pushReplacementNamed('/login');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal keluar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A314D),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Profil Saya",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: -50,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFD1DCEB),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xFF1A314D),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          
          // Profile info
          if (_isLoading)
            const CircularProgressIndicator()
          else ...[
            Text(
              _username ?? 'Loading...',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A314D),
              ),
            ),
            Text(
              _class ?? '-',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
          
          const SizedBox(height: 30),
          
          // Menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              children: [
                _buildProfileMenu(
                  Icons.person_outline,
                  "Informasi Akun",
                  () {
                    // Navigate to account info
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur dalam pengembangan'),
                      ),
                    );
                  },
                ),
                _buildProfileMenu(
                  Icons.lock_outline,
                  "Ubah Password",
                  () {
                    // Navigate to change password
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur dalam pengembangan'),
                      ),
                    );
                  },
                ),
                _buildProfileMenu(
                  Icons.settings_outlined,
                  "Pengaturan",
                  () {
                    // Navigate to settings
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur dalam pengembangan'),
                      ),
                    );
                  },
                ),
                _buildProfileMenu(
                  Icons.logout,
                  "Keluar",
                  _handleLogout,
                  color: Colors.red,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileMenu(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: color ?? const Color(0xFF1A314D)),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: color ?? Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}