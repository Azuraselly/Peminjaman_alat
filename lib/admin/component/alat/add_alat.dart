import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_alat/service/alat_service.dart';
import 'package:inventory_alat/service/kategori_service.dart';
import 'package:inventory_alat/colors.dart';

class AddAlat extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(String message, bool isSuccess) onShowNotification;

  const AddAlat({
    super.key,
    this.initialData,
    required this.onShowNotification,
  });

  @override
  State<AddAlat> createState() => _AddAlatState();
}

class _AddAlatState extends State<AddAlat> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  // HAPUS: String? _selectedKategori;  <-- TIDAK DIPERLUKAN LAGI
  int? _selectedKategoriId;
  String? _selectedKondisi;
  File? _imageFile;
  Uint8List? _imageBytes;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final AlatService _alatService = AlatService();
  final KategoriService _kategoriService = KategoriService();

  List<Map<String, dynamic>> _kategoriList = [];
  final TextEditingController _hargaController = TextEditingController();

  String? _namaError;
  String? _kategoriError;
  String? _kondisiError;
  String? _stokError;
  String? _hargaError;

  @override
  void initState() {
    super.initState();
    _loadKategori();
    if (widget.initialData != null) {
      _namaController.text = widget.initialData!['nama_alat'] ?? "";
      _stokController.text = widget.initialData!['stok_alat']?.toString() ?? "";

      // HANYA set ID kategori, jangan set nama kategori
      final kategoriData = widget.initialData!['kategori'];
      if (kategoriData != null) {
        _selectedKategoriId = kategoriData['id_kategori'] is int
            ? kategoriData['id_kategori']
            : int.tryParse(kategoriData['id_kategori']?.toString() ?? '0');
      }

      _selectedKondisi = _formatKondisi(widget.initialData!['kondisi_alat']);
      _deskripsiController.text = widget.initialData!['deskripsi'] ?? "";

      // Handle existing image (optional)
      if (widget.initialData!['gambar'] != null) {
        // Implementasi load gambar jika diperlukan
      }
    }
  }

  Future<void> _loadKategori() async {
    try {
      _kategoriList = await _kategoriService.getAllKategori();
      print('Loaded ${_kategoriList.length} categories: $_kategoriList');

      // Pastikan semua kategori memiliki ID integer yang valid
      _kategoriList = _kategoriList.map((kategori) {
        return {
          'id_kategori': kategori['id_kategori'] is int
              ? kategori['id_kategori']
              : int.tryParse(kategori['id_kategori'].toString()) ?? 0,
          'nama_kategori': kategori['nama_kategori'].toString(),
        };
      }).toList();

      setState(() {});
    } catch (e) {
      print('Error loading categories: $e');
      widget.onShowNotification('Gagal memuat kategori: $e', false);
    }
  }

  String _formatKondisi(String kondisi) {
    switch (kondisi.toLowerCase()) {
      case 'baik':
        return 'Baik';
      case 'rusak ringan':
        return 'Rusak Ringan';
      case 'rusak berat':
        return 'Rusak Berat';
      case 'hilang':
        return 'Hilang';
      default:
        return kondisi;
    }
  }

  void _validateAndSave() async {
    setState(() {
      _namaError = _namaController.text.isEmpty
          ? "Nama alat tidak boleh kosong"
          : null;
      _kategoriError = _selectedKategoriId == null ? "Pilih kategori" : null; // HANYA CEK ID
      _kondisiError = _selectedKondisi == null ? "Pilih kondisi" : null;
      _stokError = _stokController.text.isEmpty
          ? "Stok tidak boleh kosong"
          : null;
    });

    if (_namaError == null &&
        _kategoriError == null &&
        _kondisiError == null &&
        _stokError == null) {
      setState(() => _isLoading = true);

      try {
        final data = {
          "nama_alat": _namaController.text,
          "id_kategori": _selectedKategoriId, // KIRIM ID LANGSUNG
          "stok_alat": int.tryParse(_stokController.text) ?? 0,
          "kondisi_alat": _selectedKondisi!.toLowerCase(),
          "deskripsi": _deskripsiController.text,
        };

        Map<String, dynamic> result;
        String action;

        // Determine which image to use (web vs mobile)
        File? imageToUpload;
        Uint8List? imageBytesToUpload;

        if (!kIsWeb && _imageFile != null) {
          imageToUpload = _imageFile;
        } else if (kIsWeb && _imageBytes != null) {
          imageBytesToUpload = _imageBytes;
        }

        if (widget.initialData != null &&
            widget.initialData!['id_alat'] != null) {
          result = await _alatService.updateAlat(
            widget.initialData!['id_alat'],
            data,
            kIsWeb ? imageBytesToUpload : imageToUpload,
          );
          action = "memperbarui";
        } else {
          result = await _alatService.insertAlat(
            data,
            kIsWeb ? imageBytesToUpload : imageToUpload,
          );
          action = "menambahkan";
        }

        if (result['success'] == true) {
          widget.onShowNotification(
            "Berhasil $action ${_namaController.text}",
            true,
          );
          Navigator.pop(context);
        } else {
          widget.onShowNotification("Gagal menyimpan: ${result['message']}", false);
        }
      } catch (e) {
        widget.onShowNotification("Gagal menyimpan: ${e.toString()}", false);
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        if (kIsWeb) {
          // For web, read as bytes
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _imageBytes = bytes;
            _imageFile = null; // Clear file reference on web
          });
        } else {
          // For mobile, use File
          setState(() {
            _imageFile = File(pickedFile.path);
            _imageBytes = null; // Clear bytes reference on mobile
          });
        }
      }
    } catch (e) {
      widget.onShowNotification("Gagal memilih gambar: $e", false);
    }
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
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
                    child: _imageFile != null || _imageBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: kIsWeb && _imageBytes != null
                                ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                                : !kIsWeb && _imageFile != null
                                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                                    : const Icon(
                                        Icons.add_a_photo,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                          )
                        : const Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildLabel("NAMA ALAT"),
              _buildTextField(
                _namaController,
                "Masukkan nama alat",
                error: _namaError,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("KATEGORI"),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: _kategoriError != null
                                ? Border.all(color: Colors.red)
                                : null,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              isExpanded: true,
                              value: _selectedKategoriId,
                              hint: Text("Pilih Kategori"),
                              items: _kategoriList
                                  .map((k) => DropdownMenuItem<int>(
                                        value: k['id_kategori'] as int,
                                        child: Text(k['nama_kategori'].toString()),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedKategoriId = val;
                                  _kategoriError = null;
                                });
                              },
                            ),
                          ),
                        ),
                        if (_kategoriError != null)
                          Text(
                            _kategoriError!,
                            style: const TextStyle(color: Colors.red, fontSize: 11),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildDropdown(
                      "KONDISI",
                      "Pilih Kondisi",
                      ['Baik', 'Rusak Ringan', 'Rusak Berat', 'Hilang'],
                      _selectedKondisi,
                      _kondisiError,
                      (val) {
                        setState(() {
                          _selectedKondisi = val;
                          _kondisiError = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("STOK AWAL"),
                        _buildTextField(
                          _stokController,
                          "0",
                          isNumber: true,
                          error: _stokError,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildLabel("DESKRIPSI"),
              _buildTextField(_deskripsiController, "Catatan...", maxLines: 2),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _validateAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B71B9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.initialData == null
                              ? "Tambah Alat"
                              : "Update Alat",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
    int maxLines = 1,
    String? error,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        errorText: error,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String hint,
    List<String> items,
    String? selectedValue,
    String? errorText,
    Function(String?)? onChanged,
  ) {
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
              items: items
                  .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (errorText != null)
          Text(
            errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 11),
          ),
      ],
    );
  }
}