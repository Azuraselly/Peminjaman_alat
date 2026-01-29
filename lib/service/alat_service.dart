import 'package:supabase_flutter/supabase_flutter.dart';

class AlatService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllAlat() async {
  final res = await _client
      .from('alat')
      .select('''
        id_alat,
        nama_alat,
        stok_alat,
        kondisi_alat,
        deskripsi,
        kategori(id_kategori, nama_kategori)
      ''')
      .filter('deleted_at', 'is', null)
      .order('created_at');

  return List<Map<String, dynamic>>.from(res);
}

  Future<void> insertAlat(Map<String, dynamic> data) async {
    await _client.from('alat').insert({
      'nama_alat': data['name'],
      'stok_alat': int.parse(data['stok'].split(' ')[0]),
      'kondisi_alat': data['kondisi'].toLowerCase(),
      'deskripsi': data['desc'],
    });
  }

  Future<void> updateAlat(int id, Map<String, dynamic> data) async {
    await _client.from('alat').update({
      'nama_alat': data['name'],
      'stok_alat': int.parse(data['stok'].split(' ')[0]),
      'kondisi_alat': data['kondisi'].toLowerCase(),
      'deskripsi': data['desc'],
    }).eq('id_alat', id);
  }

  Future<void> deleteAlat(int id) async {
    await _client
        .from('alat')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id_alat', id);
  }
}
