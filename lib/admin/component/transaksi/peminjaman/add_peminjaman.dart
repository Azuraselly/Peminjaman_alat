import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuatPeminjamanDialog extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? initialData;

  const BuatPeminjamanDialog({super.key, this.isEdit = false, this.initialData});

  @override
  State<BuatPeminjamanDialog> createState() => _BuatPeminjamanDialogState();
}

class _BuatPeminjamanDialogState extends State<BuatPeminjamanDialog> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alatController = TextEditingController();
  final TextEditingController _tglPinjamController = TextEditingController();
  final TextEditingController _tglKembaliController = TextEditingController();

  String? _selectedKelas;
  String _selectedJumlah = "1";

  final List<String> _listKelas = ['XI TKR 1', 'XI TKR 2', 'XI TKR 3', 'XI TKR 4', 'XI TKR 5'];
  final List<String> _listJumlah = ['1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.initialData != null) {
      _namaController.text = widget.initialData!['name'] ?? "";
      _alatController.text = widget.initialData!['tool'] ?? "";
      _selectedKelas = widget.initialData!['kelas'];
      _tglPinjamController.text = widget.initialData!['date'] ?? "";
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _backIconButton(context),
                const SizedBox(width: 20),
                Text(
                  widget.isEdit ? "Edit Peminjaman" : "Buat Peminjaman",
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildLabel("ID USER / NAMA PEMINJAM"),
            _buildTextField("Masukkan nama", _namaController),
            const SizedBox(height: 15),
            _buildLabel("TINGKATAN KELAS"),
            _buildDropdown("Kelas", _listKelas, _selectedKelas, (val) => setState(() => _selectedKelas = val)),
            const SizedBox(height: 15),
            _buildLabel("ID ALAT / NAMA ALAT"),
            _buildTextField("Ketik nama alat...", _alatController),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _buildLabel("JUMLAH"),
                  _buildDropdown("1", _listJumlah, _selectedJumlah, (val) => setState(() => _selectedJumlah = val!)),
                ])),
                const SizedBox(width: 15),
                Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _buildLabel("TGL PINJAM"),
                  _buildDateField("yyyy-mm-dd", _tglPinjamController),
                ])),
              ],
            ),
            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Widget Helpers
  Widget _backIconButton(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
    child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, size: 20)),
  );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey[600])),
  );

  Widget _buildTextField(String hint, TextEditingController controller) => TextField(
    controller: controller,
    decoration: InputDecoration(hintText: hint, filled: true, fillColor: const Color(0xFFF1F1F1), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
  );

  Widget _buildDateField(String hint, TextEditingController controller) => TextField(
    controller: controller,
    readOnly: true,
    onTap: () => _selectDate(context, controller),
    decoration: InputDecoration(hintText: hint, suffixIcon: const Icon(Icons.calendar_today, size: 18), filled: true, fillColor: const Color(0xFFF1F1F1), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
  );

  Widget _buildDropdown(String hint, List<String> items, String? val, Function(String?) onChanged) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(color: const Color(0xFFF1F1F1), borderRadius: BorderRadius.circular(12)),
    child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: val, isExpanded: true, hint: Text(hint), items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged)),
  );

  Widget _buildSubmitButton() => SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF132A47), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      child: Text(widget.isEdit ? "Update Data" : "Simpan Data", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );
}