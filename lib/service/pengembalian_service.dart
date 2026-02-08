import 'package:flutter/foundation.dart';
import 'package:inventory_alat/auth/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PengembalianService {
  final _supabase = SupabaseConfig.client;

Future<List<Map<String, dynamic>>> searchPeminjamanAktif(String query) async {
  try {
    if (query.isEmpty) return [];

    final response = await _supabase
        .from('view_peminjaman_autocomplete')
        .select('id_peminjaman, username, nama_alat, search_text') 
        .ilike('search_text', '%$query%')
        .limit(10);

    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    debugPrint('Error search: $e');
    return [];
  }
}
  // 2. Ambil detail untuk preview box biru
  Future<Map<String, dynamic>?> getDetailPeminjaman(int id) async {
    try {
      final response = await _supabase
          .from('peminjaman')
          .select('*, users:id_user(username), alat:id_alat(nama_alat)')
          .eq('id_peminjaman', id)
          .single();
      return response;
    } catch (e) {
      debugPrint('Error detail peminjaman: $e');
      return null;
    }
  }
  

  // 3. Simpan Pengembalian & Update Stok
  Future<bool> createPengembalian({
    required int idPeminjaman,
    required String tanggalKembali,
    required String kondisi,
    required String catatan,
  }) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) return false;

      // Ambil data jumlah pinjam & id_alat untuk balikin stok
      final dataPinjam = await _supabase
          .from('peminjaman')
          .select('id_alat, jumlah')
          .eq('id_peminjaman', idPeminjaman)
          .single();

      final int idAlat = dataPinjam['id_alat'];
      final int jumlahKembali = dataPinjam['jumlah'];

      // A. Masukkan data ke tabel pengembalian
      await _supabase.from('pengembalian').insert({
        'id_peminjaman': idPeminjaman,
        'tanggal_kembali': tanggalKembali,
        'kondisi_saat_dikembalikan': kondisi,
        'catatan': catatan,
        'diterima_oleh': currentUser.id,
      });

      // B. Update status peminjaman
      await _supabase
          .from('peminjaman')
          .update({'status': 'dikembalikan'})
          .eq('id_peminjaman', idPeminjaman);

      // C. Update Stok Alat (Menambah kembali stok)
      final resAlat = await _supabase
          .from('alat')
          .select('stok_alat')
          .eq('id_alat', idAlat)
          .single();
      
      int stokBaru = (resAlat['stok_alat'] as int) + jumlahKembali;

      await _supabase
          .from('alat')
          .update({'stok_alat': stokBaru})
          .eq('id_alat', idAlat);

      return true;
    } catch (e) {
      debugPrint('Error creating pengembalian: $e');
      return false;
    }
  }

  // 4. Update data pengembalian
  Future<bool> updatePengembalian({
    required int idPengembalian,
    required String tanggalKembali,
    required String kondisi,
    required String catatan,
  }) async {
    try {
      await _supabase.from('pengembalian').update({
        'tanggal_kembali': tanggalKembali,
        'kondisi_saat_dikembalikan': kondisi,
        'catatan': catatan,
      }).eq('id_pengembalian', idPengembalian);
      return true;
    } catch (e) {
      debugPrint('Error updating pengembalian: $e');
      return false;
    }
  }

  Future<void> deletePengembalian(int id) async {
    try {
      await _supabase
          .from('pengembalian')
          .delete()
          .eq('id_pengembalian', id);
    } catch (e) {
      throw Exception("Gagal menghapus data: $e");
    }
  }

  // 5. Ambil semua list pengembalian
  Future<List<Map<String, dynamic>>> getListPengembalian() async {
    try {
      final response = await _supabase.from('pengembalian').select('''
            *,
            peminjaman!pengembalian_id_peminjaman_fkey(
              users!peminjaman_id_user_fkey(username),
              alat!peminjaman_id_alat_fkey(nama_alat)
            )
          ''').order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching list pengembalian: $e');
      return [];
    }
  }
}