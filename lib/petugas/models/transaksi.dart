class Transaksi {
  final String id, nama, kelas, alat, tanggal;
  final bool isTerlambat;
  String status; // 'menunggu', 'dipinjam', 'kembali'

  Transaksi({
    required this.id,
    required this.nama,
    required this.kelas,
    required this.alat,
    required this.tanggal,
    this.isTerlambat = false,
    this.status = 'menunggu',
  });
}