// ============================================================================
// DATABASE SERVICE
// ============================================================================
// This file contains service classes to interact with your PostgreSQL database
// Using Supabase as an example (you can adapt to your backend)

import 'package:inventory_alat/models.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Get Supabase client instance
  // final _supabase = Supabase.instance.client;

  // ============================================================================
  // USER OPERATIONS
  // ============================================================================

  Future<List<AppUser>> getAllUsers() async {
    try {
      // Example query:
      // final response = await _supabase
      //   .from('users')
      //   .select()
      //   .order('created_at', ascending: false);
      
      // return (response as List)
      //   .map((json) => AppUser.fromJson(json))
      //   .toList();
      
      // Dummy return for now
      return [];
    } catch (e) {
      print('Error getting users: $e');
      rethrow;
    }
  }

  Future<AppUser?> getUserById(String userId) async {
    try {
      // final response = await _supabase
      //   .from('users')
      //   .select()
      //   .eq('id_user', userId)
      //   .single();
      
      // return AppUser.fromJson(response);
      
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<int> getUserCount() async {
    try {
      // final response = await _supabase
      //   .from('users')
      //   .select('id_user', const FetchOptions(count: CountOption.exact));
      
      // return response.count ?? 0;
      
      return 0;
    } catch (e) {
      print('Error counting users: $e');
      return 0;
    }
  }

  // ============================================================================
  // ALAT (TOOL) OPERATIONS
  // ============================================================================

  Future<List<Alat>> getAllAlat({bool includeDeleted = false}) async {
    try {
      // var query = _supabase
      //   .from('alat')
      //   .select('*, kategori(*)');
      
      // if (!includeDeleted) {
      //   query = query.is_('deleted_at', null);
      // }
      
      // final response = await query.order('created_at', ascending: false);
      
      // return (response as List)
      //   .map((json) => Alat.fromJson(json))
      //   .toList();
      
      return [];
    } catch (e) {
      print('Error getting alat: $e');
      rethrow;
    }
  }

  Future<Alat?> getAlatById(int idAlat) async {
    try {
      // final response = await _supabase
      //   .from('alat')
      //   .select('*, kategori(*)')
      //   .eq('id_alat', idAlat)
      //   .single();
      
      // return Alat.fromJson(response);
      
      return null;
    } catch (e) {
      print('Error getting alat: $e');
      return null;
    }
  }

  Future<List<Alat>> getAlatByKategori(int idKategori) async {
    try {
      // final response = await _supabase
      //   .from('alat')
      //   .select('*, kategori(*)')
      //   .eq('id_kategori', idKategori)
      //   .is_('deleted_at', null)
      //   .order('nama_alat');
      
      // return (response as List)
      //   .map((json) => Alat.fromJson(json))
      //   .toList();
      
      return [];
    } catch (e) {
      print('Error getting alat by kategori: $e');
      rethrow;
    }
  }

  Future<int> getAlatCount() async {
    try {
      // final response = await _supabase
      //   .from('alat')
      //   .select('id_alat', const FetchOptions(count: CountOption.exact))
      //   .is_('deleted_at', null);
      
      // return response.count ?? 0;
      
      return 0;
    } catch (e) {
      print('Error counting alat: $e');
      return 0;
    }
  }

  Future<void> createAlat(Alat alat) async {
    try {
      // await _supabase.from('alat').insert(alat.toJson());
    } catch (e) {
      print('Error creating alat: $e');
      rethrow;
    }
  }

  Future<void> updateAlat(int idAlat, Map<String, dynamic> updates) async {
    try {
      // updates['updated_at'] = DateTime.now().toIso8601String();
      // await _supabase
      //   .from('alat')
      //   .update(updates)
      //   .eq('id_alat', idAlat);
    } catch (e) {
      print('Error updating alat: $e');
      rethrow;
    }
  }

  Future<void> softDeleteAlat(int idAlat) async {
    try {
      // await _supabase
      //   .from('alat')
      //   .update({'deleted_at': DateTime.now().toIso8601String()})
      //   .eq('id_alat', idAlat);
    } catch (e) {
      print('Error deleting alat: $e');
      rethrow;
    }
  }

  // ============================================================================
  // KATEGORI OPERATIONS
  // ============================================================================

  Future<List<Kategori>> getAllKategori() async {
    try {
      // final response = await _supabase
      //   .from('kategori')
      //   .select()
      //   .order('nama_kategori');
      
      // return (response as List)
      //   .map((json) => Kategori.fromJson(json))
      //   .toList();
      
      return [];
    } catch (e) {
      print('Error getting kategori: $e');
      rethrow;
    }
  }

  Future<int> getKategoriCount() async {
    try {
      // final response = await _supabase
      //   .from('kategori')
      //   .select('id_kategori', const FetchOptions(count: CountOption.exact));
      
      // return response.count ?? 0;
      
      return 0;
    } catch (e) {
      print('Error counting kategori: $e');
      return 0;
    }
  }

  // ============================================================================
  // PEMINJAMAN OPERATIONS
  // ============================================================================

  Future<List<Peminjaman>> getAllPeminjaman({StatusPeminjaman? status}) async {
    try {
      // var query = _supabase
      //   .from('peminjaman')
      //   .select('*, user:users(*), approver:users!disetujui_oleh(*), alat(*, kategori(*))');
      
      // if (status != null) {
      //   query = query.eq('status', status.name);
      // }
      
      // final response = await query.order('created_at', ascending: false);
      
      // return (response as List)
      //   .map((json) => Peminjaman.fromJson(json))
      //   .toList();
      
      return [];
    } catch (e) {
      print('Error getting peminjaman: $e');
      rethrow;
    }
  }

  Future<List<Peminjaman>> getPeminjamanByUser(String userId) async {
    try {
      // final response = await _supabase
      //   .from('peminjaman')
      //   .select('*, user:users(*), alat(*, kategori(*))')
      //   .eq('id_user', userId)
      //   .order('created_at', ascending: false);
      
      // return (response as List)
      //   .map((json) => Peminjaman.fromJson(json))
      //   .toList();
      
      return [];
    } catch (e) {
      print('Error getting user peminjaman: $e');
      rethrow;
    }
  }

  Future<int> getPeminjamanCount({StatusPeminjaman? status}) async {
    try {
      // var query = _supabase
      //   .from('peminjaman')
      //   .select('id_peminjaman', const FetchOptions(count: CountOption.exact));
      
      // if (status != null) {
      //   query = query.eq('status', status.name);
      // }
      
      // final response = await query;
      // return response.count ?? 0;
      
      return 0;
    } catch (e) {
      print('Error counting peminjaman: $e');
      return 0;
    }
  }

  Future<int> getPeminjamanTerlambatCount() async {
    try {
      // final today = DateTime.now().toIso8601String().split('T')[0];
      // final response = await _supabase
      //   .from('peminjaman')
      //   .select('id_peminjaman', const FetchOptions(count: CountOption.exact))
      //   .neq('status', 'dikembalikan')
      //   .lt('batas_pengembalian', today);
      
      // return response.count ?? 0;
      
      return 0;
    } catch (e) {
      print('Error counting late peminjaman: $e');
      return 0;
    }
  }

  Future<void> createPeminjaman(Peminjaman peminjaman) async {
    try {
      // await _supabase.from('peminjaman').insert(peminjaman.toJson());
    } catch (e) {
      print('Error creating peminjaman: $e');
      rethrow;
    }
  }

  Future<void> updatePeminjamanStatus({
    required int idPeminjaman,
    required StatusPeminjaman newStatus,
    String? approvedBy,
  }) async {
    try {
      // final updates = {
      //   'status': newStatus.name,
      //   'updated_at': DateTime.now().toIso8601String(),
      // };
      
      // if (approvedBy != null) {
      //   updates['disetujui_oleh'] = approvedBy;
      //   updates['waktu_setujui'] = DateTime.now().toIso8601String();
      // }
      
      // await _supabase
      //   .from('peminjaman')
      //   .update(updates)
      //   .eq('id_peminjaman', idPeminjaman);
    } catch (e) {
      print('Error updating peminjaman status: $e');
      rethrow;
    }
  }

  // ============================================================================
  // PENGEMBALIAN OPERATIONS
  // ============================================================================

  Future<List<Pengembalian>> getAllPengembalian() async {
    try {
      // final response = await _supabase
      //   .from('pengembalian')
      //   .select('*, peminjaman(*, user:users(*), alat(*)), receiver:users!diterima_oleh(*)')
      //   .order('created_at', ascending: false);
      
      // return (response as List)
      //   .map((json) => Pengembalian.fromJson(json))
      //   .toList();
      
      return [];
    } catch (e) {
      print('Error getting pengembalian: $e');
      rethrow;
    }
  }

  Future<void> createPengembalian(Pengembalian pengembalian) async {
    try {
      // Start a transaction to:
      // 1. Insert pengembalian record
      // 2. Update peminjaman status to 'dikembalikan'
      // 3. Update alat stock if needed
      
      // await _supabase.from('pengembalian').insert(pengembalian.toJson());
      
      // if (pengembalian.idPeminjaman != null) {
      //   await updatePeminjamanStatus(
      //     idPeminjaman: pengembalian.idPeminjaman!,
      //     newStatus: StatusPeminjaman.dikembalikan,
      //   );
      // }
    } catch (e) {
      print('Error creating pengembalian: $e');
      rethrow;
    }
  }

  // ============================================================================
  // LOG AKTIVITAS OPERATIONS
  // ============================================================================

  Future<List<LogAktivitas>> getAllLogAktivitas({int limit = 50}) async {
    try {
      // final response = await _supabase
      //   .from('log_aktifitas')
      //   .select('*, user:users(*)')
      //   .order('created_at', ascending: false)
      //   .limit(limit);
      
      // return (response as List)
      //   .map((json) => LogAktivitas.fromJson(json))
      //   .toList();
      
      return [];
    } catch (e) {
      print('Error getting log aktivitas: $e');
      rethrow;
    }
  }

  Future<void> createLog({
    required String userId,
    required String action,
  }) async {
    try {
      // await _supabase.from('log_aktifitas').insert({
      //   'id_user': userId,
      //   'aksi': action,
      //   'created_at': DateTime.now().toIso8601String(),
      // });
    } catch (e) {
      print('Error creating log: $e');
      rethrow;
    }
  }

  // ============================================================================
  // DASHBOARD STATS
  // ============================================================================

  Future<DashboardStats> getDashboardStats() async {
    try {
      // Run parallel queries for better performance
      // final results = await Future.wait([
      //   getUserCount(),
      //   getAlatCount(),
      //   getPeminjamanCount(),
      //   getKategoriCount(),
      //   getPeminjamanCount(status: StatusPeminjaman.disetujui),
      //   getPeminjamanTerlambatCount(),
      // ]);
      
      // return DashboardStats(
      //   totalUsers: results[0],
      //   totalAlat: results[1],
      //   totalTransaksi: results[2],
      //   totalKategori: results[3],
      //   peminjamanAktif: results[4],
      //   peminjamanTerlambat: results[5],
      // );
      
      // Return dummy data for now
      return DashboardStats(
        totalUsers: 0,
        totalAlat: 0,
        totalTransaksi: 0,
        totalKategori: 0,
        peminjamanAktif: 0,
        peminjamanTerlambat: 0,
      );
    } catch (e) {
      print('Error getting dashboard stats: $e');
      rethrow;
    }
  }
}