import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriService {
  final supabase = Supabase.instance.client;

  // Get Supabase client for realtime listeners
  SupabaseClient get client => supabase;

  Future<List<Map<String, dynamic>>> getAllKategori() async {
    try {
      final res = await supabase
          .from('kategori')
          .select('*')
          .order('nama_kategori');
      
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      print('Error fetching kategori: $e');
      rethrow;
    }
  }

  Future<void> addKategori(Map<String, dynamic> data) async {
    try {
      // Validasi nama kategori
      if (data['nama_kategori'] == null || data['nama_kategori'].toString().trim().isEmpty) {
        throw Exception('Nama kategori tidak boleh kosong');
      }

      await supabase.from('kategori').insert({
        'nama_kategori': data['nama_kategori'].toString().trim(),
        'deskripsi_kategori': data['deskripsi_kategori']?.toString().trim(),
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error adding kategori: $e');
      rethrow;
    }
  }

  Future<void> updateKategori(int id, Map<String, dynamic> data) async {
    try {
      // Validasi nama kategori
      if (data['nama_kategori'] == null || data['nama_kategori'].toString().trim().isEmpty) {
        throw Exception('Nama kategori tidak boleh kosong');
      }

      await supabase.from('kategori').update({
        'nama_kategori': data['nama_kategori'].toString().trim(),
        'deskripsi_kategori': data['deskripsi_kategori']?.toString().trim(),
      }).eq('id_kategori', id);
    } catch (e) {
      print('Error updating kategori: $e');
      rethrow;
    }
  }

  Future<void> deleteKategori(int id) async {
    try {
      await supabase.from('kategori').delete().eq('id_kategori', id);
    } catch (e) {
      print('Error deleting kategori: $e');
      rethrow;
    }
  }
}