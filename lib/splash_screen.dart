import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi Animasi Fade-In
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Pindah ke Halaman Login setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      // Gantilah 'LoginPage()' dengan nama class halaman login kamu
      Navigator.pushReplacementNamed(context, '/login'); 
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan background Deep Blue agar selaras dengan Header Admin kamu
      backgroundColor: const Color(0xFF162D4A), 
      body: Stack(
        children: [
          // Dekorasi Lingkaran Abstrak di pojok (opsional agar lebih menarik)
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),
          
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo atau Icon Inventory
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      size: 80,
                      color: Color(0xFF162D4A),
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  // Judul Aplikasi
                  Text(
                    "INVENTORY ALAT",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  
                  // Slogan
                  Text(
                    "Kelola Peralatan dengan Mudah",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 50),
                  
                  // Loading Indicator warna Gold
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFCC00)),
                    strokeWidth: 3,
                  ),
                ],
              ),
            ),
          ),
          
          // Teks Copyright di bawah
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Text(
              "v1.0.0 • SMK TECH",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.white30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}