import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
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