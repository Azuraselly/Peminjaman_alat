import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/colors.dart';
import 'package:image_picker/image_picker.dart';

class AddAlat extends StatefulWidget {
  final Function(String name) onSaveSuccess; // Callback untuk notifikasi

  const AddAlat({super.key, required this.onSaveSuccess});

  @override
  State<AddAlat> createState() => _AddAlatState();
}

class _AddAlatState extends State<AddAlat> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  String? _selectedKategori;
  String? _selectedKondisi;
  File? _image; // Untuk menyimpan file gambar
  final ImagePicker _picker = ImagePicker();

  final List<String> _listKategori = ['Alat Tangan', 'K3', 'Servis'];
  final List<String> _listKondisi = ['Baik', 'Rusak', 'Hilang'];

  // Fungsi untuk mengambil gambar
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView( // Agar tidak error pixel overflow saat keyboard muncul
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
                    "Tambah Alat",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                 alignment: Alignment.center,
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, color: AppColors.abuh, size: 60),
                           
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 35),

              _buildLabel("NAMA ALAT"),
              const SizedBox(height: 8),
              _buildTextField(_namaController, "Masukkan nama alat"),
              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdown("KATEGORI", "Pilih", _listKategori, _selectedKategori, (val) {
                      setState(() => _selectedKategori = val);
                    }),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildDropdown("KONDISI", "Pilih", _listKondisi, _selectedKondisi, (val) {
                      setState(() => _selectedKondisi = val);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              _buildLabel("STOK AWAL"),
              const SizedBox(height: 8),
              _buildTextField(_stokController, "0", isNumber: true),
              const SizedBox(height: 15),

              _buildLabel("DESKRIPSI"),
              const SizedBox(height: 8),
              _buildTextField(_deskripsiController, "Fungsi atau catatan alat", maxLines: 2),
              const SizedBox(height: 25),

              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_namaController.text.isNotEmpty && _selectedKategori != null) {
                        String namaAlat = _namaController.text;
                        Navigator.pop(context);
                        
                        // Memanggil fungsi notifikasi di halaman utama
                        widget.onSaveSuccess(namaAlat);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Nama dan Kategori wajib diisi!")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.seli,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
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
    return Text(text, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.abuh));
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 15, color: AppColors.abuh),
        filled: true,
        fillColor: AppColors.form,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdown(String label, String hint, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: AppColors.form, borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(hint, style: GoogleFonts.poppins(color: AppColors.abuh, fontSize: 14)),
              value: selectedValue,
              items: items.map((val) => DropdownMenuItem(value: val, child: Text(val, style: GoogleFonts.poppins(fontSize: 14)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}