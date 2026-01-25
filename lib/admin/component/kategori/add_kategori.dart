import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/colors.dart';

class AddKategori extends StatefulWidget {
  final Function(String name) onSaveSuccess; // Callback untuk notifikasi

  const AddKategori({super.key, required this.onSaveSuccess});

  @override
  State<AddKategori> createState() => _AddKategoriState();
}

class _AddKategoriState extends State<AddKategori> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        // Agar tidak error pixel overflow saat keyboard muncul
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Text(
                    "Tambah Kategori",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              _buildLabel("NAMA KATEGORI"),
              const SizedBox(height: 8),
              _buildTextField(_namaController, "Masukkan nama kategori"),
              const SizedBox(height: 15),

              _buildLabel("DESKRIPSI"),
              const SizedBox(height: 8),
              _buildTextField(
                _deskripsiController,
                "Masukkan deskripsi",
                maxLines: 2,
              ),
              const SizedBox(height: 25),

              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_namaController.text.isNotEmpty) {
                        String namaKategori = _namaController.text;
                        Navigator.pop(context);

                        // Memanggil fungsi notifikasi di halaman utama
                        widget.onSaveSuccess(namaKategori);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Nama dan Kategori wajib diisi!"),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.seli,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      "Simpan Alat",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.abuh,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 15, color: AppColors.abuh),
        filled: true,
        fillColor: AppColors.form,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
