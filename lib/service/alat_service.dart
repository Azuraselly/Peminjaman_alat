import 'dart:io'; // Penting untuk File
import 'package:supabase_flutter/supabase_flutter.dart';

class AlatService {
  final SupabaseClient _client = Supabase.instance.client;

  // 1. Fungsi Helper untuk Upload Gambar
  Future<String?> _uploadGambar(File imageFile) async {
    try {
      // Buat nama file unik
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = 'foto_alat/$fileName';

      // Upload ke bucket 'inventory' (Pastikan bucket ini sudah dibuat & Public di Dashboard Supabase)
      await _client.storage.from('inventory').upload(path, imageFile);

      // Ambil Public URL
      final String imageUrl = _client.storage.from('inventory').getPublicUrl(path);
      return imageUrl;
    } catch (e) {
      print("Error Upload Gambar: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllAlat() async {
    final res = await _client.from('alat').select('''
        id_alat,
        nama_alat,
        stok_alat,
        kondisi_alat,
        deskripsi,
        gambar, 
        kategori(id_kategori, nama_kategori)
      ''').filter('deleted_at', 'is', null).order('created_at');

    return List<Map<String, dynamic>>.from(res);
  }

  // 2. Insert Alat dengan Gambar
  Future<void> insertAlat(Map<String, dynamic> data, File? imageFile) async {
    String? imageUrl;
    
    // Jika ada file gambar, upload dulu
    if (imageFile != null) {
      imageUrl = await _uploadGambar(imageFile);
    }

    await _client.from('alat').insert({
      'nama_alat': data['name'],
      'stok_alat': int.parse(data['stok'].split(' ')[0]),
      'kondisi_alat': data['kondisi'], // Sesuaikan dengan Enum di DB (case sensitive)
      'deskripsi': data['desc'],
      'gambar': imageUrl, // Simpan URL gambar
      'id_kategori': data['id_kategori'], // Pastikan id_kategori dikirim
    });
  }

  // 3. Update Alat dengan Gambar
  Future<void> updateAlat(int id, Map<String, dynamic> data, File? newImageFile) async {
    String? imageUrl = data['gambar']; // Gunakan gambar lama secara default

    // Jika user pilih gambar baru, upload gambar baru tersebut
    if (newImageFile != null) {
      imageUrl = await _uploadGambar(newImageFile);
    }

    await _client.from('alat').update({
      'nama_alat': data['name'],
      'stok_alat': int.parse(data['stok'].split(' ')[0]),
      'kondisi_alat': data['kondisi'],
      'deskripsi': data['desc'],
      'gambar': imageUrl,
      'id_kategori': data['id_kategori'],
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id_alat', id);
  }

  Future<void> deleteAlat(int id) async {
    await _client
        .from('alat')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id_alat', id);
  }
}