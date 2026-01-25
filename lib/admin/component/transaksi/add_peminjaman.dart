import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/colors.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  // Controller untuk mengambil data nama
  final TextEditingController _namaController = TextEditingController();

  // Variabel penampung pilihan dropdown
  String? _selectedKelas;
  String? _selectedRole;

  // Daftar data dropdown
  final List<String> _listKelas = [
    'XI TKR 1',
    'XI TKR 2',
    'XI TKR 3',
    'XI TKR 4',
    'XI TKR 5'
  ];
  final List<String> _listRole = ['Peminjam', 'Petugas', 'Admin'];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  "Buat Peminjaman",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Label Nama Lengkap
            _buildLabel("ID USER/NAMA PEMINJAM"),
            const SizedBox(height: 8),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: "Masukkan ID user atau nama peminjam",
                hintStyle: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColors.abuh,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: AppColors.form,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // Baris Dropdown Kelas dan Role
            Row(
              children: [
                Expanded(
                  child: _buildDropdown("KELAS", "Kelas", _listKelas, _selectedKelas, (val) {
                    setState(() => _selectedKelas = val);
                  }),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildDropdown("ROLE", "Role", _listRole, _selectedRole, (val) {
                    setState(() => _selectedRole = val);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 25),
            
            Center(
              child: SizedBox(
                width: 343,
                height: 69,
                child: ElevatedButton(
                  onPressed: () {
                    // Logika ketika tombol simpan ditekan
                    String nama = _namaController.text;
                    if (nama.isNotEmpty && _selectedKelas != null && _selectedRole != null) {
                      // Tutup dialog dan kirim data kembali (opsional)
                      Navigator.pop(context);
                      
                      // Anda bisa memanggil snackbar/notifikasi di halaman utama setelah ini
                      print("Simpan: $nama, $_selectedKelas, $_selectedRole");
                    } else {
                      // Beri peringatan jika ada yang kosong
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Harap isi semua data!")),
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
                    "Simpan User",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.abuh, 
      ),
    );
  }

  // Widget Helper Dropdown yang berfungsi
  Widget _buildDropdown(String label, String hint, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.form,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(
                hint,
                style: GoogleFonts.poppins(color: AppColors.abuh, fontSize: 14),
              ),
              value: selectedValue,
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: GoogleFonts.poppins(fontSize: 14)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}