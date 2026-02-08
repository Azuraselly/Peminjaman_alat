import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/transaksi/autocomplete_field.dart';
import 'package:inventory_alat/service/peminjaman_service.dart';


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

  final PeminjamanService _peminjamanService = PeminjamanService();
  
  String? _selectedKelas;
  String _selectedJumlah = "1";
  Map<String, dynamic>? _selectedUser;
  Map<String, dynamic>? _selectedAlat;
  bool _isLoading = false;
  int? _maxStok;

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

  Future<void> _handleSubmit() async {
    // Validasi
    if (_selectedUser == null) {
      _showError('Pilih peminjam terlebih dahulu');
      return;
    }
    if (_selectedAlat == null) {
      _showError('Pilih alat terlebih dahulu');
      return;
    }
    if (_selectedKelas == null) {
      _showError('Pilih kelas terlebih dahulu');
      return;
    }
    if (_tglPinjamController.text.isEmpty || _tglKembaliController.text.isEmpty) {
      _showError('Lengkapi tanggal peminjaman');
      return;
    }

    int jumlah = int.tryParse(_selectedJumlah) ?? 1;
    if (_maxStok != null && jumlah > _maxStok!) {
      _showError('Stok tidak mencukupi. Stok tersedia: $_maxStok');
      return;
    }

    setState(() => _isLoading = true);

    bool success;
    if (widget.isEdit) {
      success = await _peminjamanService.updatePeminjaman(
        idPeminjaman: widget.initialData!['id_peminjaman'],
        idUser: _selectedUser!['id_user'],
        tingkatanKelas: _selectedKelas!,
        idAlat: _selectedAlat!['id_alat'],
        jumlah: jumlah,
        tanggalPinjam: _tglPinjamController.text,
        batasPengembalian: _tglKembaliController.text,
      );
    } else {
      success = await _peminjamanService.createPeminjaman(
        idUser: _selectedUser!['id_user'],
        tingkatanKelas: _selectedKelas!,
        idAlat: _selectedAlat!['id_alat'],
        jumlah: jumlah,
        tanggalPinjam: _tglPinjamController.text,
        batasPengembalian: _tglKembaliController.text,
      );
    }

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context, true); // Return true untuk refresh list
      _showSuccess(widget.isEdit ? 'Data berhasil diupdate' : 'Peminjaman berhasil dibuat');
    } else {
      _showError('Gagal menyimpan data');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
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
            
            // AUTOCOMPLETE UNTUK USER
            AutocompleteField(
              label: "ID USER / NAMA PEMINJAM",
              hint: "Ketik nama peminjam...",
              controller: _namaController,
              displayKey: 'username',
              subtitleKey: 'class',
              onSearch: (query) => _peminjamanService.searchUsers(query),
              onSelected: (user) {
                setState(() {
                  _selectedUser = user;
                  _namaController.text = user['username'];
                  _selectedKelas = user['class'];
                });
              },
            ),
            
            const SizedBox(height: 15),
            _buildLabel("TINGKATAN KELAS"),
            _buildDropdown("Kelas", _listKelas, _selectedKelas, (val) => setState(() => _selectedKelas = val)),
            
            const SizedBox(height: 15),
            
            // AUTOCOMPLETE UNTUK ALAT
            AutocompleteField(
              label: "ID ALAT / NAMA ALAT",
              hint: "Ketik nama alat...",
              controller: _alatController,
              displayKey: 'nama_alat',
              subtitleKey: 'stok_alat',
              onSearch: (query) => _peminjamanService.searchAlat(query),
              onSelected: (alat) {
                setState(() {
                  _selectedAlat = alat;
                  _alatController.text = alat['nama_alat'];
                  _maxStok = alat['stok_alat'];
                });
              },
            ),
            
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
            const SizedBox(height: 15),
            _buildLabel("BATAS KEMBALI"),
            _buildDateField("yyyy-mm-dd", _tglKembaliController),
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
      onPressed: _isLoading ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF132A47),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
          : Text(
              widget.isEdit ? "Update Data" : "Simpan Data",
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            ),
    ),
  );
}