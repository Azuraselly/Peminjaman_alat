import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
<<<<<<< HEAD
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await _supabase.from('users').select().order('username');
    return List<Map<String, dynamic>>.from(response);
  }

 Future<void> addUser(Map<String, dynamic> data) async {
    await _supabase.from('users').insert({
      'username': data['username'], 
      'role': data['role'].toString().toLowerCase(),
      'status': data['status'] ?? true, // Kirim boolean true/false
    });
  }

Future<void> updateUser(dynamic id, Map<String, dynamic> data) async {
    await _supabase.from('users').update({
      'username': data['username'],
      'role': data['role'].toString().toLowerCase(),
      'status': data['status'],
    }).eq('id_user', id);
  }
  // DELETE
 Future<void> deleteUser(dynamic id) async {
    if (id == null) return;
    await _supabase.from('users').delete().eq('id_user', id);
  }
}
=======
  final SupabaseClient _client = Supabase.instance.client;

  // Ambil semua user
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final res = await _client.from('users').select().order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(res);
  }

  // Tambah user
  Future<void> addUser(Map<String, dynamic> data) async {
    final res = await _client.from('users').insert({
      'username': data['name'],
      'role': data['role']?.toLowerCase(),
      'status': data['isActive'],
      'class': data['class'],
    });
    if (res == null) throw Exception("Gagal menambahkan user");
  }

  // Update user
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    final res = await _client
        .from('users')
        .update({
          'username': data['name'],
          'role': data['role']?.toLowerCase(),
          'status': data['isActive'],
          'class': data['class'],
        })
        .eq('id_user', id);
    if (res == null) throw Exception("Gagal update user");
  }

  // Hapus user
  Future<void> deleteUser(String id) async {
    final res = await _client.from('users').delete().eq('id_user', id);
    if (res == null) throw Exception("Gagal hapus user");
  }

  // Stream realtime (Supabase Realtime)
  Stream<List<Map<String, dynamic>>> userStream() {
    return _client
        .from('users')
        .stream(primaryKey: ['id_user'])
        .order('created_at', ascending: false)
        .map((event) => List<Map<String, dynamic>>.from(event));
  }
}
>>>>>>> 4fe59e9 (target 3)
