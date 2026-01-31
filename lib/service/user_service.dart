import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await _supabase.from('users').select().order('username');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching users: $e');
      rethrow;
    }
  }

  Future<void> addUser(Map<String, dynamic> data) async {
    try {
      // Jika ada email dan password, buat user di Supabase Auth dulu
      if (data['email'] != null && data['password'] != null) {
        // Validasi email sebelum mencoba sign up
        String email = data['email'];
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email) || email.split('@')[0].length < 3) {
          throw Exception('Email tidak valid. Gunakan format: user@example.com');
        }
        
        // 1. Sign up user di Supabase Auth
        final authResponse = await _supabase.auth.signUp(
          email: email,
          password: data['password'],
        );

        if (authResponse.user == null) {
          throw Exception('Gagal membuat user di Supabase Auth');
        }

        // 2. Buat record di tabel users dengan id_user dari auth
        final userData = {
          'id_user': authResponse.user!.id,
          'username': data['username'], 
          'role': data['role'].toString().toLowerCase(),
          'status': data['status'] ?? true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        // Tambahkan class hanya jika ada dan bukan "-"
        if (data['class'] != null && data['class'] != '-' && data['class'].toString().isNotEmpty) {
          userData['class'] = data['class'];
        }
        
        await _supabase.from('users').insert(userData);
      } else {
        // Untuk edit user (tanpa email/password)
        // Update data user yang sudah ada
        final updateData = {
          'username': data['username'],
          'role': data['role'].toString().toLowerCase(),
          'status': data['status'],
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        // Tambahkan class hanya jika ada dan bukan "-"
        if (data['class'] != null && data['class'] != '-' && data['class'].toString().isNotEmpty) {
          updateData['class'] = data['class'];
        } else if (data['role'] != 'peminjam') {
          // Untuk role non-peminjam, set class ke null
          updateData['class'] = null;
        }
        
        await _supabase.from('users').update(updateData).eq('id_user', data['id_user']);
      }
    } on AuthException catch (e) {
      // Handle specific auth errors
      if (e.code == 'email_address_invalid') {
        throw Exception('Format email tidak valid. Gunakan format: user@example.com (minimal 3 karakter sebelum @)');
      } else if (e.code == 'weak_password') {
        throw Exception('Password terlalu lemah. Minimal 6 karakter.');
      } else if (e.code == 'email_exists') {
        throw Exception('Email sudah terdaftar. Gunakan email lain.');
      } else {
        throw Exception('Error auth: ${e.message}');
      }
    } catch (e) {
      print('Error adding/updating user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    try {
      await _supabase.from('users').update({
        'username': data['username'],
        'role': data['role'].toString().toLowerCase(),
        'status': data['status'],
        'class': data['class'],
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id_user', id);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }
  
  Future<void> deleteUser(String id) async {
    try {
      if (id.isEmpty) return;
      await _supabase.from('users').delete().eq('id_user', id);
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
}