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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String? _selectedRole;
  String? _selectedClass;
  bool _status = true;

  // Variabel untuk menyimpan pesan error
  String? _emailError;
  String? _passwordError;
  String? _usernameError;
  String? _roleError;

  final List<String> _listRole = ['admin', 'petugas', 'peminjam'];
 final List<String> _listClass = [
  'X TKR 1', 'X TKR 2', 'X TKR 3', 'X TKR 4', 'X TKR 5', 'X TKR 6',
  'XI TKR 1', 'XI TKR 2', 'XI TKR 3', 'XI TKR 4', 'XI TKR 5', 'XI TKR 6',
  'XII TKR 1', 'XII TKR 2', 'XII TKR 3', 'XII TKR 4', 'XII TKR 5', 'XII TKR 6'
];


  @override
  void initState() {
    super.initState();
    // Jika sedang Edit, masukkan data lama ke form
    if (widget.initialData != null) {
      _usernameController.text = widget.initialData!['username'] ?? '';
      _selectedRole = widget.initialData!['role'];
      _selectedClass = widget.initialData!['class'];
      _status = widget.initialData!['status'] ?? true;
      // Untuk edit, email dan password tidak ditampilkan
    }
  }
void _validateAndSave() {
  setState(() {
    if (widget.initialData == null) {
      _emailError = _emailController.text.trim().isEmpty 
        ? "Email tidak boleh kosong" 
        : (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(_emailController.text)
           ? "Format email tidak valid" 
           : null);
      
      _passwordError = _passwordController.text.trim().isEmpty 
        ? "Password tidak boleh kosong" 
        : (_passwordController.text.length < 6 
           ? "Password minimal 6 karakter" 
           : null);
    }

    _usernameError = _usernameController.text.trim().isEmpty ? "Username tidak boleh kosong" : null;
    _roleError = _selectedRole == null ? "Pilih role" : null;
  });

  // Cetak log untuk debug
  print("=== DEBUG VALIDASI ===");
  print("Email: ${_emailController.text}, Error: $_emailError");
  print("Password: ${_passwordController.text}, Error: $_passwordError");
  print("Username: ${_usernameController.text}, Error: $_usernameError");
  print("Role: $_selectedRole, Error: $_roleError");
  print("Class: $_selectedClass");
  print("Status: $_status");
  print("=====================");

  bool hasNoErrors = _usernameError == null && _roleError == null;
  if (widget.initialData == null) {
    hasNoErrors = hasNoErrors && _emailError == null && _passwordError == null;
  }

  if (hasNoErrors) {
    final result = {
      "username": _usernameController.text.trim(),
      "role": _selectedRole,
      "status": _status,
    };
    if (widget.initialData == null) {
      result["email"] = _emailController.text.trim();
      result["password"] = _passwordController.text;
    }
    if (_selectedRole == 'peminjam' && _selectedClass != null) {
      result["class"] = _selectedClass;
    }
    print("=== DATA YANG DIKIRIM ===");
    print(result);
    Navigator.pop(context, result);
  } else {
    print("Terdapat error, data tidak disimpan");
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
            
            // Input Email (hanya untuk tambah baru)
            if (widget.initialData == null) ...[
              _buildLabel("EMAIL"),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Masukkan email (contoh: user@example.com)",
                  errorText: _emailError,
                  filled: true,
                  fillColor: AppColors.form,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 15),
              
              // Input Password (hanya untuk tambah baru)
              _buildLabel("PASSWORD"),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Masukkan password (min 6 karakter)",
                  errorText: _passwordError,
                  filled: true,
                  fillColor: AppColors.form,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 15),
            ],

            // Input Username
            _buildLabel("USERNAME"),
            const SizedBox(height: 8),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Masukkan username",
                errorText: _usernameError,
                filled: true,
                fillColor: AppColors.form,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            
            const SizedBox(height: 15),

            // Dropdown Role
            _buildDropdownField("ROLE", _listRole, _selectedRole, _roleError, (val) {
              setState(() { 
                _selectedRole = val; 
                _roleError = null;
                // Reset class when role changes
                if (val != 'peminjam') {
                  _selectedClass = null;
                }
              });
            }),
            
            const SizedBox(height: 15),

            // Dropdown Class (hanya untuk peminjam)
            if (_selectedRole == 'peminjam')
              _buildDropdownField("CLASS", _listClass, _selectedClass, null, (val) {
                setState(() { _selectedClass = val; });
              }),
            
            const SizedBox(height: 15),

            // Status Toggle
            _buildLabel("STATUS"),
            SwitchListTile(
              title: Text(_status ? 'Aktif' : 'Nonaktif'),
              value: _status,
              onChanged: (value) {
                setState(() => _status = value);
              },
              activeColor: AppColors.seli,
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
            border: error != null ? Border.all(color: Colors.red) : null,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: items.map((e) => DropdownMenuItem(
                value: e, 
                child: Text(e.toUpperCase(), style: const TextStyle(fontSize: 14))
              )).toList(),
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