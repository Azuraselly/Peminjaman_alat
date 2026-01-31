import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuatPengembalianDialog extends StatefulWidget {
  const BuatPengembalianDialog({super.key});

  @override
  State<BuatPengembalianDialog> createState() => _BuatPengembalianDialogState();
}

class _BuatPengembalianDialogState extends State<BuatPengembalianDialog> {
  String selectedKondisi = "Baik";
  final TextEditingController _dateController = TextEditingController();

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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Buat Pengembalian",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // ID Peminjaman
              _buildLabel("ID PEMINJAMAN"),
              _buildTextField("Cari ID Peminjaman..."),
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
                    Text("PREVIEW DATA", 
                      style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF3B6790))),
                    const SizedBox(height: 5),
                    Text("Scanner OBD II - Azura Aulia", 
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF162D4A))),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Tanggal Kembali
              _buildLabel("TANGGAL KEMBALI"),
              TextField(
                controller: _dateController,
                readOnly: true,
                decoration: _inputDecoration("dd/mm/yyyy", suffixIcon: Icons.calendar_today_outlined),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
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
                        child: Text(value, style: GoogleFonts.poppins(fontSize: 14)),
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
              _buildTextField("Keterangan kondisi alat...", maxLines: 3),
              const SizedBox(height: 30),

              // Tombol Simpan (Warna Hijau sesuai gambar)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Tambahkan logika simpan di sini
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF279454),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text("Simpan Pengembalian", 
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
      child: Text(text, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint, {IconData? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade100,
      suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey, size: 20) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    );
  }
}