import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/colors.dart';

class AddUserDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData; // Jika null = Tambah, jika isi = Edit

  const AddUserDialog({super.key, this.initialData});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final TextEditingController _namaController = TextEditingController();
  String? _selectedKelas;
  String? _selectedRole;

  // Variabel untuk menyimpan pesan error
  String? _namaError;
  String? _kelasError;
  String? _roleError;

  final List<String> _listKelas = ['XI TKR 1', 'XI TKR 2', 'XI TKR 3', 'XI TKR 4'];
  final List<String> _listRole = ['Peminjam', 'Petugas', 'Admin'];

  @override
  void initState() {
    super.initState();
    // Jika sedang Edit, masukkan data lama ke form
    if (widget.initialData != null) {
      _namaController.text = widget.initialData!['name'];
      _selectedKelas = widget.initialData!['class'];
      _selectedRole = widget.initialData!['role'];
    }
  }

  void _validateAndSave() {
    setState(() {
      // Validasi Nama
      _namaError = _namaController.text.trim().isEmpty ? "Nama tidak boleh kosong" : null;
      // Validasi Kelas
      _kelasError = _selectedKelas == null ? "Pilih kelas" : null;
      // Validasi Role
      _roleError = _selectedRole == null ? "Pilih role" : null;
    });

    // Jika semua null (artinya tidak ada error), maka simpan
    if (_namaError == null && _kelasError == null && _roleError == null) {
      Navigator.pop(context, {
        "name": _namaController.text.trim(),
        "class": _selectedKelas,
        "role": _selectedRole,
        "status": widget.initialData?['status'] ?? "Aktif",
        "isActive": widget.initialData?['isActive'] ?? true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialData == null ? "Tambah User" : "Edit User",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),
            
            // Input Nama
            _buildLabel("NAMA LENGKAP"),
            const SizedBox(height: 8),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: "Masukkan nama lengkap",
                errorText: _namaError, // Pesan error warna merah di sini
                filled: true,
                fillColor: AppColors.form,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            
            const SizedBox(height: 15),

            // Dropdown Kelas & Role
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDropdownField("KELAS", _listKelas, _selectedKelas, _kelasError, (val) {
                    setState(() { _selectedKelas = val; _kelasError = null; });
                  }),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildDropdownField("ROLE", _listRole, _selectedRole, _roleError, (val) {
                    setState(() { _selectedRole = val; _roleError = null; });
                  }),
                ),
              ],
            ),

            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _validateAndSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.seli,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text("SIMPAN DATA", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.abuh));
  }

  Widget _buildDropdownField(String label, List<String> items, String? value, String? error, Function(String?) onChanged) {
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
            border: error != null ? Border.all(color: Colors.red) : null, // Border merah jika error
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(error, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
      ],
    );
  }
}