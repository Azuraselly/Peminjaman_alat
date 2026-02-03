import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/peminjam/models/peminjam_models.dart';
import 'package:inventory_alat/service/peminjaman_service.dart';

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
  DateTime _batasPengembalian = DateTime.now().add(const Duration(days: 7));
  bool _isProcessing = false;

  Future<void> _processCheckout() async {
    if (widget.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang kosong')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      await _service.createPeminjamanCart(
        items: widget.items,
        batasPengembalian: _batasPengembalian,
      );

      widget.onClearCart();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Peminjaman berhasil diajukan!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to riwayat
        // You might want to use a proper navigation method here
      }
    } catch (e) {
      print('Error checkout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengajukan peminjaman: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _batasPengembalian,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A314D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _batasPengembalian) {
      setState(() {
        _batasPengembalian = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "Keranjang Pinjam",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF1A314D),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          // List Items
          Expanded(
            child: widget.items.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) => _buildCartCard(index),
                  ),
          ),
        ],
      ),
      bottomSheet: widget.items.isEmpty ? null : _buildCheckoutPanel(),
    );
  }

  Widget _buildCartCard(int index) {
    final item = widget.items[index];
    final alat = item.alat;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFD1DCEB),
              borderRadius: BorderRadius.circular(12),
              image: alat.gambar != null
                  ? DecorationImage(
                      image: NetworkImage(alat.gambar!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: alat.gambar == null
                ? const Icon(
                    Icons.build_rounded,
                    color: Color(0xFF1A314D),
                  )
                : null,
          ),
          const SizedBox(width: 15),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alat.namaAlat,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Kategori: ${alat.kategori}",
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                
                // Quantity controls
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                      onPressed: item.canDecrease
                          ? () => widget.onUpdateQuantity(index, item.jumlah - 1)
                          : null,
                      color: item.canDecrease
                          ? const Color(0xFF1A314D)
                          : Colors.grey,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "${item.jumlah}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      onPressed: item.canIncrease
                          ? () => widget.onUpdateQuantity(index, item.jumlah + 1)
                          : null,
                      color: item.canIncrease
                          ? const Color(0xFF1A314D)
                          : Colors.grey,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "/ ${alat.stokAlat}",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete button
          IconButton(
            onPressed: () => widget.onRemove(index),
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          )
        ],
      ),
    );
  }

  Widget _buildCheckoutPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Estimasi Pengembalian:",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${_batasPengembalian.day}/${_batasPengembalian.month}/${_batasPengembalian.year}",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A314D),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: _selectDate,
                icon: const Icon(
                  Icons.calendar_month,
                  color: Color(0xFF1A314D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          // Total items
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Item:",
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
                Text(
                  "${widget.items.length} alat",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          
          // Checkout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _processCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A314D),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      "Ajukan Peminjaman",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
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
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            "Keranjangmu kosong",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            "Pilih alat di beranda untuk meminjam",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}