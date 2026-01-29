import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final _client = Supabase.instance.client;

  // READ
  Future<List<Map<String, dynamic>>> getUsers() async {
    final res = await _client
        .from('users')
        .select()
        .order('created_at');

    return List<Map<String, dynamic>>.from(res);
  }

  // CREATE
  Future<void> addUser(Map<String, dynamic> data) async {
    await _client.from('users').insert({
      'username': data['name'],
      'kelas': data['class'],
      'role': data['role'],
      'status': data['isActive'] ?? true,
    });
  }

  // UPDATE
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await _client.from('users').update({
      'username': data['name'],
      'kelas': data['class'],
      'role': data['role'],
      'status': data['isActive'],
    }).eq('id_user', id);
  }

  // DELETE
  Future<void> deleteUser(String id, user) async {
    await _client.from('users').delete().eq('id_user', id);
  }

  Future getAllUsers() async {}
}
