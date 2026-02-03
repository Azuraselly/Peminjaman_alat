import 'package:inventory_alat/auth/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PengembalianService {
  final _supabase = SupabaseConfig.client;

  // Search peminjaman yang belum dikembalikan
  Future<List<Map<String, dynamic>>> searchPeminjamanAktif(String query) async {
    try {
      final response = await _supabase
          .from('peminjaman')
          .select('''
            id_peminjaman,
            users!peminjaman_id_user_fkey(username),
            alat!peminjaman_id_alat_fkey(nama_alat),
            tanggal_pinjam,
            batas_pengembalian
          ''')
          .eq('status', 'disetujui')
          .or('id_peminjaman.eq.$query,users.username.ilike.%$query%')
          .limit(10);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error searching peminjaman: $e');
      return [];
    }
  }

  // Get detail peminjaman untuk preview
  Future<Map<String, dynamic>?> getDetailPeminjaman(int idPeminjaman) async {
    try {
      final response = await _supabase
          .from('peminjaman')
          .select('''
            *,
            users!peminjaman_id_user_fkey(username),
            alat!peminjaman_id_alat_fkey(nama_alat)
          ''')
          .eq('id_peminjaman', idPeminjaman)
          .single();
      return response;
    } catch (e) {
      print('Error fetching detail: $e');
      return null;
    }
  }

  // Create pengembalian
Future<bool> createPengembalian({
  required int idPeminjaman,
  required String tanggalKembali,
  required String kondisi,
  required String catatan,
}) async {
  try {
    final currentUser = _supabase.auth.currentUser;

    if (currentUser == null) {
      print("User belum login");
      return false;
    }

    await _supabase.from('pengembalian').insert({
      'id_peminjaman': idPeminjaman,
      'tanggal_kembali': tanggalKembali,
      'kondisi_saat_dikembalikan': kondisi,
      'catatan': catatan,
      'diterima_oleh': currentUser.id, 
    });

    await _supabase
        .from('peminjaman')
        .update({'status': 'dikembalikan'})
        .eq('id_peminjaman', idPeminjaman);

    return true;
  } catch (e) {
    print('Error creating pengembalian: $e');
    return false;
  }
}

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
    print('Error updating pengembalian: $e');
    return false;
  }
}


  // Get list pengembalian
  Future<List<Map<String, dynamic>>> getListPengembalian() async {
    try {
      final response = await _supabase
          .from('pengembalian')
          .select('''
            *,
            peminjaman!pengembalian_id_peminjaman_fkey(
              users!peminjaman_id_user_fkey(username),
              alat!peminjaman_id_alat_fkey(nama_alat)
            )
          ''')
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching pengembalian: $e');
      return [];
    }
  }
}