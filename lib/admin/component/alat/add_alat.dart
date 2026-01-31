import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_alat/service/alat_service.dart';
// Sesuaikan dengan path project kamu
// import 'package:inventory_alat/colors.dart'; 

class AddAlat extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  // Ubah ke Map agar konsisten dengan data yang dikirim balik
  final Function(Map<String, dynamic> data) onSaveSuccess; 

  const AddAlat({super.key, this.initialData, required this.onSaveSuccess});

  @override
  State<AddAlat> createState() => _AddAlatState();
}

class _AddAlatState extends State<AddAlat> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  String? _selectedKategori;
  String? _selectedKondisi;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final AlatService _alatService = AlatService();

  final List<String> _listKategori = ['Alat Tangan', 'K3', 'Servis'];
  final List<String> _listKondisi = ['Baik', 'Rusak Ringan', 'Rusak Berat', 'Hilang'];

  String? _namaError;
  String? _kategoriError;
  String? _kondisiError;
  String? _stokError;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _namaController.text = widget.initialData!['name'] ?? "";
      _stokController.text = widget.initialData!['stok']?.toString().split(' ')[0] ?? "";
      _selectedKategori = widget.initialData!['kategori'];
      _selectedKondisi = widget.initialData!['kondisi'];
      _deskripsiController.text = widget.initialData!['desc'] ?? "";
    }
  }

<<<<<<< HEAD
  void _validateAndSave() {
=======
  void _validateAndSave() async {
>>>>>>> 4fe59e9 (target 3)
    setState(() {
      _namaError = _namaController.text.isEmpty ? "Nama alat tidak boleh kosong" : null;
      _kategoriError = _selectedKategori == null ? "Pilih kategori" : null;
      _kondisiError = _selectedKondisi == null ? "Pilih kondisi" : null;
      _stokError = _stokController.text.isEmpty ? "Stok tidak boleh kosong" : null;
    });

<<<<<<< HEAD
    if (_namaError == null && _kategoriError == null && _kondisiError == null && _stokError == null) {
      widget.onSaveSuccess({
        "name": _namaController.text,
        "kategori": _selectedKategori,
        "stok": "${_stokController.text} Unit",
        "kondisi": _selectedKondisi,
        "desc": _deskripsiController.text,
        // Tambahkan path image jika perlu: "image": _image?.path,
      });
      Navigator.pop(context);
=======
    if (_namaError == null &&
        _kategoriError == null &&
        _kondisiError == null &&
        _stokError == null) {
      final data = {
        "nama_alat": _namaController.text,
        "id_kategori": _listKategori.indexOf(_selectedKategori!) + 1, // contoh id kategori
        "stok_alat": int.tryParse(_stokController.text) ?? 0,
        "kondisi_alat": _selectedKondisi!.toLowerCase(),
        "deskripsi": _deskripsiController.text,
      };

      try {
        if (widget.initialData != null && widget.initialData!['id'] != null) {
          await _alatService.updateAlat(widget.initialData!['id'], data);
        } else {
          await _alatService.addAlat(data);
        }
        widget.onSaveSuccess(data);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
>>>>>>> 4fe59e9 (target 3)
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
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
                    widget.initialData == null ? "Tambah Alat" : "Edit Alat",
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          )
                        : const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildLabel("NAMA ALAT"),
              _buildTextField(_namaController, "Masukkan nama alat", error: _namaError),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown("KATEGORI", "Pilih", _listKategori, _selectedKategori, _kategoriError, (val) {
                      setState(() => _selectedKategori = val);
                    }),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildDropdown("KONDISI", "Pilih", _listKondisi, _selectedKondisi, _kondisiError, (val) {
                      setState(() => _selectedKondisi = val);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildLabel("STOK AWAL"),
              _buildTextField(_stokController, "0", isNumber: true, error: _stokError),
              const SizedBox(height: 15),
              _buildLabel("DESKRIPSI"),
              _buildTextField(_deskripsiController, "Catatan...", maxLines: 2),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _validateAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B71B9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text("Simpan Alat", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey));
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false, int maxLines = 1, String? error}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        errorText: error,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdown(String label, String hint, List<String> items, String? selectedValue, String? errorText, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: errorText != null ? Border.all(color: Colors.red) : null,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              hint: Text(hint),
              items: items.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (errorText != null) Text(errorText, style: const TextStyle(color: Colors.red, fontSize: 11)),
      ],
    );
  }
}