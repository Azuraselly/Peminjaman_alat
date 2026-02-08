import 'package:inventory_alat/admin/models/log_aktivitas.dart';
import 'package:inventory_alat/auth/supabase_config.dart';
import 'package:flutter/foundation.dart';
import 'package:inventory_alat/peminjam/models/peminjam_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeminjamanService {
  final _supabase = SupabaseConfig.client;

  // Fetch semua users untuk dropdown
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final response = await _supabase
          .from('users')
          .select('id_user, username, class')
          .eq('status', true)
          .order('username');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  // Fetch semua alat untuk dropdown
  Future<List<Map<String, dynamic>>> getAlat() async {
    try {
      final response = await _supabase
          .from('alat')
          .select('id_alat, nama_alat, stok_alat, kondisi_alat, gambar')
          .isFilter('deleted_at', null)
          .gt('stok_alat', 0)
          .order('nama_alat');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching alat: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllKategori() async {
    final response = await _supabase
        .from('kategori')
        .select()
        .order('nama_kategori');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<int> getActivePeminjamanCount() async {
    final response = await _supabase
        .from('peminjaman')
        .select('id_peminjaman')
        .neq('status', 'dikembalikan');

    return response.length;
  }

  // Search user by name (untuk autocomplete)
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      final response = await _supabase
          .from('users')
          .select('id_user, username, class')
          .eq('status', true)
          .ilike('username', '%$query%')
          .limit(10);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  // Search alat by name (untuk autocomplete)
  Future<List<Map<String, dynamic>>> searchAlat(String query) async {
    try {
      final response = await _supabase
          .from('alat')
          .select('id_alat, nama_alat, stok_alat')
          .isFilter('deleted_at', null)
          .gt('stok_alat', 0)
          .ilike('nama_alat', '%$query%')
          .limit(10);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error searching alat: $e');
      return [];
    }
  }

Future<bool> createPeminjamanCart({
    required List<KeranjangItem> items,
    required DateTime batasPengembalian,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // Ambil profil user untuk mendapatkan kelasnya
      final userProfile = await getUserProfile();
      final String userClass = userProfile?['class'] ?? '-';

      // 1. Siapkan data peminjaman
      final List<Map<String, dynamic>> insertData = items
          .map(
            (item) => {
              'id_user': user.id,
              'tingkatan_kelas': userClass, // Gunakan variabel userClass hasil fetch profil
              'id_alat': item.alat.idAlat,
              'jumlah': item.jumlah,
              'tanggal_pinjam': DateTime.now().toIso8601String(),
              'batas_pengembalian': batasPengembalian.toIso8601String(),
              'status': 'diajukan',
            },
          )
          .toList();

      // 2. Masukkan data ke tabel peminjaman
      await _supabase.from('peminjaman').insert(insertData);

      // 3. Update stok (Logika tetap sama)
      for (var item in items) {
        final resAlat = await _supabase
            .from('alat')
            .select('stok_alat')
            .eq('id_alat', item.alat.idAlat)
            .single();

        int stokSekarang = resAlat['stok_alat'];
        int stokBaru = stokSekarang - item.jumlah;

        await _supabase
            .from('alat')
            .update({'stok_alat': stokBaru})
            .eq('id_alat', item.alat.idAlat);
      }

      return true;
    } catch (e) {
      debugPrint('Error cart peminjaman & update stok: $e');
      return false;
    }
  }

  Future<bool> createPeminjaman({
    required String idUser,
    required String tingkatanKelas,
    required int idAlat,
    required int jumlah,
    required String tanggalPinjam,
    required String batasPengembalian,
  }) async {
    try {
      String finalKelas = tingkatanKelas;
      if (finalKelas.isEmpty) {
        final userProfile = await getUserProfile();
        finalKelas = userProfile?['class'] ?? '-';
      }

      // 1. Masukkan data peminjaman
      await _supabase.from('peminjaman').insert({
        'id_user': idUser,
        'tingkatan_kelas': finalKelas,
        'id_alat': idAlat,
        'jumlah': jumlah,
        'tanggal_pinjam': tanggalPinjam,
        'batas_pengembalian': batasPengembalian,
        'status': 'diajukan',
      });

      // 2. LOGIKA OTOMATIS: Ambil stok lama dan kurangi
      final resAlat = await _supabase
          .from('alat')
          .select('stok_alat')
          .eq('id_alat', idAlat)
          .single();

      int stokBaru = (resAlat['stok_alat'] as int) - jumlah;

      await _supabase
          .from('alat')
          .update({'stok_alat': stokBaru})
          .eq('id_alat', idAlat);

      return true;
    } catch (e) {
      debugPrint('Error single insert & update stok: $e');
      return false;
    }
  }

  // Update peminjaman
  Future<bool> updatePeminjaman({
    required int idPeminjaman,
    required String idUser,
    required String tingkatanKelas,
    required int idAlat,
    required int jumlah,
    required String tanggalPinjam,
    required String batasPengembalian,
  }) async {
    try {
      await _supabase
          .from('peminjaman')
          .update({
            'id_user': idUser,
            'tingkatan_kelas': tingkatanKelas,
            'id_alat': idAlat,
            'jumlah': jumlah,
            'tanggal_pinjam': tanggalPinjam,
            'batas_pengembalian': batasPengembalian,
          })
          .eq('id_peminjaman', idPeminjaman);
      return true;
    } catch (e) {
      print('Error updating peminjaman: $e');
      return false;
    }
  }

  // Delete peminjaman
  Future<bool> deletePeminjaman(int idPeminjaman) async {
    try {
      await _supabase
          .from('peminjaman')
          .delete()
          .eq('id_peminjaman', idPeminjaman);
      return true;
    } catch (e) {
      print('Error deleting peminjaman: $e');
      return false;
    }
  }

  // Get user profil
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) return null;

      final response = await _supabase
          .from('users')
          .select('username, class')
          .eq('id_user', user.id)
          .single();

      return response;
    } catch (e) {
      print('Error getUserProfile: $e');
      return null;
    }
  }

  // Get detail peminjaman
  Future<Map<String, dynamic>?> getDetailPeminjaman(int idPeminjaman) async {
    try {
      final response = await _supabase
          .from('peminjaman')
          .select('''
            *,
            users!peminjaman_id_user_fkey(username, class),
            alat!peminjaman_id_alat_fkey(nama_alat),
            users!peminjaman_disetujui_oleh_fkey(username)
          ''')
          .eq('id_peminjaman', idPeminjaman)
          .single();
      return response;
    } catch (e) {
      print('Error fetching detail: $e');
      return null;
    }
  }

  // Get list peminjaman dengan filter
  Future<List<Map<String, dynamic>>> getListPeminjaman({String? status}) async {
    try {
      var query = _supabase.from('peminjaman').select('''
          *,
          users!peminjaman_id_user_fkey(username),
          alat!peminjaman_id_alat_fkey(nama_alat)
        ''');

      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query.order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Map<String, int>> getDashboardStats() async {
    try {
      final resUsers = await _supabase
          .from('users')
          .select('*')
          .count(CountOption.exact);
      final resAlat = await _supabase
          .from('alat')
          .select('*')
          .count(CountOption.exact);
      final resPeminjaman = await _supabase
          .from('peminjaman')
          .select('*')
          .count(CountOption.exact);
      final resKategori = await _supabase
          .from('kategori')
          .select('*')
          .count(CountOption.exact);

      return {
        'users': resUsers.count,
        'alat': resAlat.count,
        'transaksi': resPeminjaman.count,
        'kategori': resKategori.count,
      };
    } catch (e) {
      debugPrint('Error dashboard stats: $e');
      return {'users': 0, 'alat': 0, 'transaksi': 0, 'kategori': 0};
    }
  }

  /// Fungsi untuk Admin (Melihat semua peminjaman)
  Future<List<Map<String, dynamic>>> getPeminjaman() async {
    try {
      final response = await _supabase
          .from('peminjaman')
          .select('''
            id_peminjaman,
            id_user,
            id_alat,
            jumlah,
            tingkatan_kelas,
            tanggal_pinjam,
            batas_pengembalian,
            status,
            users:id_user (username, class),
            alat:id_alat (
              nama_alat, 
              stok_alat, 
              gambar,
              kategori:id_kategori (nama_kategori)
            )
          ''')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetch peminjaman: $e');
      return [];
    }
  }

  // Fungsi untuk User Peminjam (Melihat riwayat sendiri)
  Future<List<PeminjamanItem>> getUserPeminjaman() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      final response = await _supabase
          .from('peminjaman')
          .select('''
            *,
            alat:id_alat (
              nama_alat, 
              gambar,
              kategori:id_kategori (nama_kategori)
            )
          ''')
          .eq('id_user', user.id)
          .order('created_at', ascending: false);

      return (response as List)
          .map((e) => PeminjamanItem.fromMap(e))
          .toList();
    } catch (e) {
      debugPrint('Error getUserPeminjaman: $e');
      return [];
    }
  }

  Future<List<LogAktivitas>> getLogs() async {
    try {
      final response = await _supabase
          .from('log_aktifitas')
          .select('''
          id_aktifitas,
          aksi,
          created_at,
          users:id_user (username, role)
        ''')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => LogAktivitas.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error fetch logs: $e');
      return [];
    }
  }

  // ===============================
  // RECENT SEARCH (LOCAL MEMORY)
  // ===============================

  final List<String> _recentSearches = [];

  void addRecentSearch(String query) {
    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
    }
  }

  List<String> getRecentSearches() {
    return _recentSearches;
  }

  void clearRecentSearches() {
    _recentSearches.clear();
  }
}
