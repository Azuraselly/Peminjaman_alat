import 'package:flutter/material.dart';
import 'package:inventory_alat/auth/login_page.dart';
import 'package:inventory_alat/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomHeader extends StatefulWidget {
  const CustomHeader({super.key});

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  bool _hasNewActivity = false;
  String _adminName = "Unknow";
  String _adminRole = "ADMIN";

  @override
  void initState() {
    super.initState();
    _loadAdminData();
    _listenToLogs();
  }

  // 1. Ambil Nama Admin Login
  Future<void> _loadAdminData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final data = await Supabase.instance.client
          .from('users')
          .select()
          .eq('id_user', user.id)
          .single();
      if (mounted) {
        setState(() {
          _adminName = data['username'] ?? "Admin";
          _adminRole = (data['role'] ?? "ADMIN").toString().toUpperCase();
        });
      }
    }
  }

  // 2. Real-time Listen ke tabel log_aktivitas
  void _listenToLogs() {
    Supabase.instance.client
        .from('log_aktivitas')
        .stream(primaryKey: ['id']) // Pastikan nama primary key sesuai di DB
        .listen((data) {
          if (data.isNotEmpty && mounted) {
            setState(() => _hasNewActivity = true);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      padding: const EdgeInsets.fromLTRB(25, 50, 25, 30),
      decoration: BoxDecoration(
        color: AppColors.seli,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _adminName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22, // Ukuran disesuaikan agar proporsional
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _adminRole,
                  style: GoogleFonts.poppins(
                    color: AppColors.selly,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildNotificationIcon(), // Gunakan widget baru ini
          const SizedBox(width: 10),
          _buildLogout(context),
        ],
      ),
    );
  }

  // Widget Notifikasi dengan Badge
  Widget _buildNotificationIcon() {
    return InkWell(
      onTap: () {
        setState(() => _hasNewActivity = false); // Hilangkan badge saat ditekan
        // Navigator.push ke halaman riwayat
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.abumud.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none, color: Colors.white, size: 24),
          ),
          if (_hasNewActivity)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.green, // Lingkaran hijau
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: AppColors.selly,
            padding: const EdgeInsets.all(12),
            child: const Icon(Icons.person, size: 40, color: AppColors.seli),
          ),
        ),
        const CircleAvatar(radius: 5, backgroundColor: Colors.green),
      ],
    );
  }

  Widget _buildLogout(BuildContext context) {
    return InkWell(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.abumud.withOpacity(0.25),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.logout, color: Colors.white, size: 24),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin keluar?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}