import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';

class AlatService {
  final supabase = Supabase.instance.client;

  // Get Supabase client for realtime listeners
  SupabaseClient get client => supabase;

  // 1. Fungsi Helper untuk Upload Gambar
  Future<String?> _uploadGambar(dynamic imageSource) async {
    try {
      // Buat nama file unik
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = 'foto_alat/$fileName';

      if (kIsWeb && imageSource is Uint8List) {
        // For web, upload bytes directly
        await supabase.storage.from('inventory').uploadBinary(path, imageSource);
      } else if (!kIsWeb && imageSource is File) {
        // For mobile, upload file
        await supabase.storage.from('inventory').upload(path, imageSource);
      } else {
        return null; // Unsupported type
      }

      // Ambil Public URL
      final String imageUrl = supabase.storage.from('inventory').getPublicUrl(path);
      return imageUrl;
    } catch (e) {
      print("Error Upload Gambar: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllAlat() async {
    try {
      final res = await supabase.from('alat').select('''
          id_alat,
          nama_alat,
          stok_alat,
          kondisi_alat,
          deskripsi,
          gambar,
          created_at,
          updated_at,
          kategori(id_kategori, nama_kategori)
        ''').filter('deleted_at', 'is', null).order('created_at');

      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      print('Error fetching alat: $e');
      rethrow;
    }
  }

  // 2. Insert Alat dengan Gambar
  Future<Map<String, dynamic>> insertAlat(Map<String, dynamic> data, dynamic imageSource) async {
    String? imageUrl;
    
    // Jika ada file gambar, upload dulu
    if (imageSource != null) {
      imageUrl = await _uploadGambar(imageSource);
    }

    try {
      final response = await supabase.from('alat').insert({
        'nama_alat': data['nama_alat'],
        'stok_alat': data['stok_alat'],
        'kondisi_alat': data['kondisi_alat'],
        'deskripsi': data['deskripsi'],
        'gambar': imageUrl,
        'id_kategori': data['id_kategori'],
      }).select('id_alat, nama_alat');
      
      return {'success': true, 'data': response.first};
    } catch (e) {
      print('Error inserting alat: $e');
      rethrow;
    }
  }

  // 3. Update Alat dengan Gambar
  Future<Map<String, dynamic>> updateAlat(int id, Map<String, dynamic> data, dynamic newImageSource) async {
    String? imageUrl = data['gambar']; // Gunakan gambar lama secara default

    // Jika user pilih gambar baru, upload gambar baru tersebut
    if (newImageSource != null) {
      imageUrl = await _uploadGambar(newImageSource);
    }

    try {
      final response = await supabase.from('alat').update({
        'nama_alat': data['nama_alat'],
        'stok_alat': data['stok_alat'],
        'kondisi_alat': data['kondisi_alat'],
        'deskripsi': data['deskripsi'],
        'gambar': imageUrl,
        'id_kategori': data['id_kategori'],
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id_alat', id).select('id_alat, nama_alat');
      
      return {'success': true, 'data': response.first};
    } catch (e) {
      print('Error updating alat: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteAlat(int id) async {
    try {
      final response = await supabase
          .from('alat')
          .delete()
          .eq('id_alat', id);
      
      return {'success': true, 'data': null};
    } catch (e) {
      print('Error deleting alat: $e');
      rethrow;
    }
  }

  // Get single alat by ID
  Future<Map<String, dynamic>?> getAlatById(int id) async {
    try {
      final res = await supabase.from('alat').select('''
          id_alat,
          nama_alat,
          stok_alat,
          kondisi_alat,
          deskripsi,
          gambar,
          harga_alat,
          created_at,
          updated_at,
          kategori(id_kategori, nama_kategori)
        ''').eq('id_alat', id).filter('deleted_at', 'is', null).single();
      
      return res;
    } catch (e) {
      print('Error fetching alat by ID: $e');
      return null;
    }
  }
}