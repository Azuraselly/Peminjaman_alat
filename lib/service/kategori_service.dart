import 'package:supabase_flutter/supabase_flutter.dart';

class KategoriService {
  final supabase = Supabase.instance.client;

  // Get Supabase client for realtime listeners
  SupabaseClient get client => supabase;

  Future<List<Map<String, dynamic>>> getAllKategori() async {
    final res = await supabase
        .from('kategori')
        .select('*')
        .order('nama_kategori');
    
    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> addKategori(String namaKategori) async {
    await supabase
        .from('kategori')
        .insert({'nama_kategori': namaKategori});
  }

  Future<void> updateKategori(int id, String namaKategori) async {
    await supabase
        .from('kategori')
        .update({'nama_kategori': namaKategori})
        .eq('id_kategori', id);
  }

  Future<void> deleteKategori(int id) async {
    await supabase
        .from('kategori')
        .delete()
        .eq('id_kategori', id);
  }
}