import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/service/alat_service.dart';
import 'package:inventory_alat/service/peminjaman.dart';
import 'package:inventory_alat/service/user_service.dart';

class BuatPeminjamanDialog extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? initialData;

  const BuatPeminjamanDialog({
    super.key,
    this.isEdit = false,
    this.initialData,
  });

  @override
  State<BuatPeminjamanDialog> createState() => _BuatPeminjamanDialogState();
}

class _BuatPeminjamanDialogState extends State<BuatPeminjamanDialog> {
  final TextEditingController _tglPinjamController = TextEditingController();
  final TextEditingController _tglKembaliController = TextEditingController();

  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> alatList = [];

  String? _selectedKelas;
  String _selectedJumlah = "1";
  int? _idPeminjaman;
  String? selectedUserId;
  int? selectedAlatId;

  final List<String> _listKelas = [
    'XI TKR 1',
    'XI TKR 2',
    'XI TKR 3',
    'XI TKR 4',
    'XI TKR 5',
  ];
  final List<String> _listJumlah = ['1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    loadDropdownData();

    if (widget.isEdit && widget.initialData != null) {
      final data = widget.initialData!;
      _idPeminjaman = data['id_peminjaman'];
      selectedUserId = data['id_user'];
      selectedAlatId = data['id_alat'];
      _selectedKelas = data['tingkatan_kelas'];
      _tglPinjamController.text = data['tanggal_pinjam'].toString();
      _tglKembaliController.text = data['batas_pengembalian'].toString();
      _selectedJumlah = data['jumlah'].toString();
    }
  }

  Future<void> loadDropdownData() async {
    userList = await UserService().getAllUsers();
    alatList = await AlatService().getAllAlat();
    setState(() {});
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
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
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildLabel("Pilih User"),
            _buildUserDropdown(),
            const SizedBox(height: 15),
            _buildLabel("Pilih Alat"),
            _buildAlatDropdown(),
            const SizedBox(height: 15),
            _buildLabel("Tingkat Kelas"),
            _buildDropdown(
              "Kelas",
              _listKelas,
              _selectedKelas,
              (val) => setState(() => _selectedKelas = val),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Jumlah"),
                      _buildDropdown(
                        "1",
                        _listJumlah,
                        _selectedJumlah,
                        (val) => setState(() => _selectedJumlah = val!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Tanggal Pinjam"),
                      _buildDateField("yyyy-mm-dd", _tglPinjamController),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildLabel("Batas Pengembalian"),
            _buildDateField("yyyy-mm-dd", _tglKembaliController),
            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _backIconButton(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 20),
        ),
      );

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.grey[600],
          ),
        ),
      );

  Widget _buildDateField(String hint, TextEditingController controller) =>
      TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate(context, controller),
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
          filled: true,
          fillColor: const Color(0xFFF1F1F1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      );

  Widget _buildDropdown(
          String hint, List<String> items, String? val, Function(String?) onChanged) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: val,
            isExpanded: true,
            hint: Text(hint),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      );

  Widget _buildUserDropdown() => DropdownButton<String>(
  value: selectedUserId,
  hint: const Text("Pilih User"),
  isExpanded: true,
  items: userList.map((u){
    return DropdownMenuItem(
      value: u['id_user'] as String, // pakai String
      child: Text(u['username']),
    );
  }).toList(),
  onChanged: (val) => setState(()=>selectedUserId=val),);

  Widget _buildAlatDropdown() => DropdownButtonFormField<int>(
        value: selectedAlatId,
        items: alatList
            .map((a) => DropdownMenuItem(
                  value: a['id_alat'] as int,
                  child: Text(a['nama_alat']),
                ))
            .toList(),
        onChanged: (v) => setState(() => selectedAlatId = v),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      );

  Widget _buildSubmitButton() => SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () async {
            if (selectedUserId == null ||
                selectedAlatId == null ||
                _selectedKelas == null ||
                _tglPinjamController.text.isEmpty ||
                _tglKembaliController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Data belum lengkap")));
              return;
            }

            if (widget.isEdit) {
              await PeminjamanService().updatePeminjaman(
                id: _idPeminjaman!,
                idUser: selectedUserId!,
                idAlat: selectedAlatId!,
                kelas: _selectedKelas!,
                tanggalPinjam: _tglPinjamController.text,
                batas: _tglKembaliController.text,
                jumlah: int.parse(_selectedJumlah),
              );
            } else {
              await PeminjamanService().addPeminjaman(
                idUser: selectedUserId!,
                idAlat: selectedAlatId!,
                kelas: _selectedKelas!,
                tanggalPinjam: _tglPinjamController.text,
                batas: _tglKembaliController.text,
                jumlah: int.parse(_selectedJumlah),
              );
            }

            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF132A47),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(
            widget.isEdit ? "Update Data" : "Simpan Data",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
