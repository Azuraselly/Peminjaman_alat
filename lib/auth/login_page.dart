import 'package:flutter/material.dart';
import 'package:inventory_alat/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:inventory_alat/admin/screen/beranda.dart';
import 'package:inventory_alat/petugas/screen/managemen_petugas_page.dart';
import 'package:inventory_alat/peminjam/component/main_navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;

  // =============================
  // LOGIN FUNCTION (FIX)
  // =============================
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = response.user;

      if (user == null) {
        _showErrorBanner();
        return;
      }

      /// 2️⃣ AMBIL ROLE DARI TABLE users
      final userData = await supabase
          .from('users')
          .select('role')
          .eq('id_user', user.id)
          .maybeSingle();

      if (userData == null) {
        _showErrorBanner();
        return;
      }

      String role = userData['role'].toString().trim().toLowerCase();

      print("LOGIN SUCCESS");
      print("USER ID : ${user.id}");
      print("ROLE    : $role");

      if (!mounted) return;

      switch (role) {
        case 'admin':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BerandaPage()),
          );
          break;

        case 'petugas':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PetugasMainScreen()),
          );
          break;

        case 'peminjam':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigationPeminjam()),
          );
          break;

        default:
          _showErrorBanner();
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      _showErrorBanner();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorBanner() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E5E5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Error",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Data tidak valid",
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo.png', height: 180),

                const SizedBox(height: 15),

                _buildLabel("EMAIL"),
                _buildTextField(
                  controller: _emailController,
                  hint: "Masukkan email...",
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 20),

                _buildLabel("PASSWORD"),
                _buildTextField(
                  controller: _passwordController,
                  hint: "........",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscure: _obscureText,
                  onToggle: () =>
                      setState(() => _obscureText = !_obscureText),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.seli,
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      :  Text(
                          "MASUK SEKARANG",
                          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =============================
  // WIDGET HELPER
  // =============================
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.selly,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(fontSize: 12),
          prefixIcon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: onToggle,
                )
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
