import 'package:supabase_flutter/supabase_flutter.dart';

class PeminjamanService {
  final supabase = Supabase.instance.client;

  // ===============================
  // READ
  // ===============================
  Future<List<Map<String, dynamic>>> getPeminjaman() async {
    final res = await supabase
        .from('peminjaman')
        .select('''
          *,
          users(username),
          alat(nama_alat)
        ''')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  // ===============================
  // CREATE
  // ===============================
  Future<void> addPeminjaman({
  required String idUser,
  required int idAlat,
  required String kelas,
  required String tanggalPinjam,
  required String batas,
  required int jumlah,
}) async {
  await supabase.from('peminjaman').insert({
    'id_user': idUser,
    'id_alat': idAlat,
    'tingkatan_kelas': kelas,
    'tanggal_pinjam': tanggalPinjam,
    'batas_pengembalian': batas,
    'jumlah': jumlah,
    'status': 'diajukan',
  });
}

Future<void> updatePeminjaman({
  required int id,
  required String idUser,
  required int idAlat,
  required String kelas,
  required String tanggalPinjam,
  required String batas,
  required int jumlah,
}) async {
  await supabase.from('peminjaman').update({
    'id_user': idUser,
    'id_alat': idAlat,
    'tingkatan_kelas': kelas,
    'tanggal_pinjam': tanggalPinjam,
    'batas_pengembalian': batas,
    'jumlah': jumlah,
  }).eq('id_peminjaman', id);
}


  // ===============================
  // DELETE
  // ===============================
  Future<void> deletePeminjaman(int id) async {
    await supabase
        .from('peminjaman')
        .delete()
        .eq('id_peminjaman', id);
  }
}
