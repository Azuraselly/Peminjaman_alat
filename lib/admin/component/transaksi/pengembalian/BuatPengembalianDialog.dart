import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/service/pengembalian_service.dart';
import 'package:inventory_alat/admin/component/alat/autocomplete_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BuatPengembalianDialog extends StatefulWidget {
  const BuatPengembalianDialog({super.key});

  @override
  State<BuatPengembalianDialog> createState() => _BuatPengembalianDialogState();
}

class _BuatPengembalianDialogState extends State<BuatPengembalianDialog> {
  String selectedKondisi = "Baik";
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _idPeminjamanController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  final PengembalianService _pengembalianService = PengembalianService();
  Map<String, dynamic>? _selectedPeminjaman;
  bool _isLoading = false;

  Future<void> _loadPreviewData(int idPeminjaman) async {
    final detail = await _pengembalianService.getDetailPeminjaman(idPeminjaman);
    if (detail != null) {
      setState(() {
        _selectedPeminjaman = detail;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_selectedPeminjaman == null) {
      _showError('Pilih peminjaman terlebih dahulu');
      return;
    }
    if (_dateController.text.isEmpty) {
      _showError('Pilih tanggal pengembalian');
      return;
    }
 
    setState(() => _isLoading = true);

    final success = await _pengembalianService.createPengembalian(
      // Pastikan dikonversi ke int jika formatnya masih dynamic/string
      idPeminjaman: int.parse(_selectedPeminjaman!['id_peminjaman'].toString()),
      tanggalKembali: _dateController.text,
      kondisi: selectedKondisi,
      catatan: _catatanController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context, true);
      _showSuccess('Pengembalian berhasil dicatat');
    } else {
      _showError('Gagal mencatat pengembalian');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Pop Up
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Buat Pengembalian",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // AUTOCOMPLETE UNTUK ID PEMINJAMAN
              AutocompleteField(
                label: "ID PEMINJAMAN",
                hint: "Cari ID atau nama peminjam...",
                controller: _idPeminjamanController,
                displayKey: 'id_peminjaman',
                onSearch: (query) =>
                    _pengembalianService.searchPeminjamanAktif(query),
                onSelected: (peminjaman) async {
                  setState(() {
                    _selectedPeminjaman = peminjaman;
                    _idPeminjamanController.text = peminjaman['id_peminjaman']
                        .toString();
                  });
                  await _loadPreviewData(peminjaman['id_peminjaman']);
                },
              ),
              const SizedBox(height: 15),

              // Preview Data (Box Biru Muda)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDE7F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PREVIEW DATA",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3B6790),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _selectedPeminjaman != null
                          ? "${_selectedPeminjaman!['alat']['nama_alat']} - ${_selectedPeminjaman!['users']['username']}"
                          : "Pilih peminjaman untuk melihat detail",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF162D4A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Tanggal Kembali
              _buildLabel("TANGGAL KEMBALI"),
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: _inputDecoration(
                  "dd/mm/yyyy",
                  suffixIcon: Icons.calendar_today_outlined,
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
              ),
              const SizedBox(height: 15),

              // Kondisi Barang (Dropdown)
              _buildLabel("KONDISI BARANG"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedKondisi,
                    isExpanded: true,
                    items: ["Baik", "Rusak", "Hilang"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() => selectedKondisi = newValue!);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Catatan
              _buildLabel("CATATAN"),
              TextField(
                controller: _catatanController,
                maxLines: 3,
                decoration: _inputDecoration("Keterangan kondisi alat..."),
              ),
              const SizedBox(height: 30),

              // Tombol Simpan (Warna Hijau sesuai gambar)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading || _selectedPeminjaman == null
                      ? null
                      : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF279454),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text(
                          "Simpan Pengembalian",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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

  // Helper Widgets untuk merapikan kode
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {IconData? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade100,
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, color: Colors.grey, size: 20)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    );
  }
}
