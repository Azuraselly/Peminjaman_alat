import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/peminjam/models/peminjam_models.dart';
import 'package:inventory_alat/service/peminjaman_service.dart';
import 'package:intl/intl.dart';

class KeranjangPeminjam extends StatefulWidget {
  final List<KeranjangItem> items;
  final Function(int) onRemove;
  final Function(int, int) onUpdateQuantity;
  final VoidCallback onClearCart;

  const KeranjangPeminjam({
    super.key,
    required this.items,
    required this.onRemove,
    required this.onUpdateQuantity,
    required this.onClearCart,
  });

  @override
  State<KeranjangPeminjam> createState() => _KeranjangPeminjamState();
}

class _KeranjangPeminjamState extends State<KeranjangPeminjam> {
  final _service = PeminjamanService();
  DateTime _batasPengembalian = DateTime.now().add(const Duration(days: 3));
  bool _isProcessing = false;

  // Menghitung total item di keranjang
  int get _totalAlat => widget.items.fold(0, (sum, item) => sum + item.jumlah);

  Future<void> _processCheckout() async {
    if (widget.items.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      // Pastikan service menerima list KeranjangItem
      await _service.createPeminjamanCart(
        items: widget.items,
        batasPengembalian: _batasPengembalian,
      );

      if (mounted) {
        _showSuccessDialog();
        widget.onClearCart();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            Text("Berhasil!", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 10),
            Text("Permintaan peminjaman Anda telah dikirim.", 
                 textAlign: TextAlign.center,
                 style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A314D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: Text(
          "Keranjang Pinjam",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A314D),
        elevation: 0,
        centerTitle: true,
        actions: [
          if (widget.items.isNotEmpty)
            IconButton(
              onPressed: () => widget.onClearCart(),
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white70),
            )
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: widget.items.isEmpty ? _buildEmptyState() : _buildCartList(),
      bottomNavigationBar: widget.items.isEmpty ? null : _buildBottomAction(),
    );
  }

  Widget _buildCartList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return _buildCartItem(item, index);
      },
    );
  }

  Widget _buildCartItem(KeranjangItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Gambar Alat
              Container(
                width: 100,
                color: const Color(0xFFF0F4F8),
                child: item.alat.gambar != null
                    ? Image.network(item.alat.gambar!, fit: BoxFit.cover)
                    : const Icon(Icons.handyman_rounded, color: Color(0xFF1A314D), size: 40),
              ),
              // Detail Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.alat.namaAlat,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      Text(item.alat.kategori, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11)),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQtyController(item, index),
                          GestureDetector(
                            onTap: () => widget.onRemove(index),
                            child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQtyController(KeranjangItem item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _qtyButton(Icons.remove, () => widget.onUpdateQuantity(index, item.jumlah - 1), enabled: item.jumlah > 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text("${item.jumlah}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ),
          _qtyButton(Icons.add, () => widget.onUpdateQuantity(index, item.jumlah + 1), 
                    enabled: item.jumlah < item.alat.stokAlat),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap, {bool enabled = true}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18, color: enabled ? const Color(0xFF1A314D) : Colors.grey),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Picker Tanggal
          GestureDetector(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, color: Color(0xFF1A314D), size: 20),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Batas Pengembalian", style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                      Text(DateFormat('EEEE, dd MMMM yyyy').format(_batasPengembalian), 
                           style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.edit_calendar_rounded, color: Colors.grey, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Ringkasan & Button
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Pinjaman", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  Text("$_totalAlat Alat", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1A314D))),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A314D),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: _isProcessing 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text("Ajukan Pinjaman", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/11329/11329060.png', // Ilustrasi box kosong
            height: 150,
            errorBuilder: (c, e, s) => const Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text("Keranjang Masih Kosong", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
          Text("Belum ada alat yang kamu pilih untuk dipinjam.", 
               textAlign: TextAlign.center,
               style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _batasPengembalian,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1A314D), onPrimary: Colors.white, surface: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _batasPengembalian = picked);
  }
}