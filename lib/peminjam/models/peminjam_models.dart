import 'package:flutter/material.dart';

class Alat {
  final int idAlat;
  final String namaAlat;
  final String? idKategori;
  final String? namaKategori;
  final int stokAlat;
  final String kondisiAlat; // Status kondisi saat ini di gudang
  final String? deskripsi;
  final String? gambar;

  Alat({
    required this.idAlat,
    required this.namaAlat,
    this.idKategori,
    this.namaKategori,
    required this.stokAlat,
    required this.kondisiAlat,
    this.deskripsi,
    this.gambar,
  });

  int get id => idAlat;
  String get nama => namaAlat;
  int get stok => stokAlat;
  String get kategori => namaKategori ?? 'Alat';

  factory Alat.fromJson(Map<String, dynamic> json) {
    String? namaKategoriTerdeteksi;
    if (json['kategori'] != null) {
      namaKategoriTerdeteksi = json['kategori']['nama_kategori'];
    } else if (json['nama_kategori'] != null) {
      namaKategoriTerdeteksi = json['nama_kategori'];
    }

    return Alat(
      idAlat: json['id_alat'],
      namaAlat: json['nama_alat'],
      idKategori: json['id_kategori']?.toString(),
      namaKategori: namaKategoriTerdeteksi ?? 'Alat',
      stokAlat: json['stok_alat'] ?? 0,
      kondisiAlat: json['kondisi_alat'] ?? 'baik',
      deskripsi: json['deskripsi'],
      gambar: json['gambar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_alat': idAlat,
      'nama_alat': namaAlat,
      'id_kategori': idKategori,
      'stok_alat': stokAlat,
      'kondisi_alat': kondisiAlat,
      'deskripsi': deskripsi,
      'gambar': gambar,
    };
  }

  bool get isAvailable => stokAlat > 0 && kondisiAlat == 'baik';
}

class PeminjamanItem {
  final int? idPeminjaman;
  final String namaAlat;
  final String? gambarAlat;
  final DateTime tanggalPinjam;
  final DateTime batasPengembalian;
  final String status;
  final int jumlah;
  final String? kategori;
  
  // Fitur Denda & Laporan dari Petugas
  final int? denda; 
  final String? kondisiKembali;
  final String? tanggalKembali;

  PeminjamanItem({
    this.idPeminjaman,
    required this.namaAlat,
    this.gambarAlat,
    required this.tanggalPinjam,
    required this.batasPengembalian,
    required this.status,
    required this.jumlah,
    this.kategori,
    this.denda,
    this.kondisiKembali,
    this.tanggalKembali,
  });

  factory PeminjamanItem.fromMap(Map<String, dynamic> json) {
    String? kategoriFromDb;
    if (json['alat'] != null && json['alat']['kategori'] != null) {
      kategoriFromDb = json['alat']['kategori']['nama_kategori'];
    }

    return PeminjamanItem(
      idPeminjaman: json['id_peminjaman'],
      namaAlat: json['alat']?['nama_alat'] ?? 'Tidak Diketahui',
      gambarAlat: json['alat']?['gambar'],
      tanggalPinjam: DateTime.parse(json['tanggal_pinjam']),
      batasPengembalian: DateTime.parse(json['batas_pengembalian']),
      status: json['status'] ?? 'diajukan',
      jumlah: json['jumlah'] ?? 1,
      kategori: kategoriFromDb ?? 'Alat',
      denda: json['denda'], // Menangkap nilai denda dari petugas
      kondisiKembali: json['kondisi_kembali'], // Menangkap kondisi dari petugas
      tanggalKembali: json['tanggal_kembali'],
    );
  }

  // --- LOGIKA DENDA ---
  bool get isLate => DateTime.now().isAfter(batasPengembalian);

  int get hitungDenda {
    // 1. Jika sudah dikembalikan, pakai nilai denda tetap dari petugas
    if (status == 'dikembalikan') {
      return denda ?? 0;
    }
    
    // 2. Jika belum kembali tapi terlambat, hitung estimasi (5rb/hari)
    if (isLate) {
      final selisihHari = DateTime.now().difference(batasPengembalian).inDays;
      return (selisihHari > 0) ? selisihHari * 5000 : 0;
    }
    
    return 0;
  }

  String get statusDisplay {
    switch (status) {
      case 'diajukan': return 'Proses';
      case 'disetujui': return 'Aktif';
      case 'ditolak': return 'Ditolak';
      case 'dikembalikan': return 'Selesai';
      default: return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'diajukan': return Colors.orange;
      case 'disetujui': return Colors.blue;
      case 'ditolak': return Colors.red;
      case 'dikembalikan': return Colors.green;
      default: return Colors.grey;
    }
  }
}

class KeranjangItem {
  final Alat alat;
  int jumlah;

  KeranjangItem({required this.alat, this.jumlah = 1});
  int get maxJumlah => alat.stokAlat;
  bool get canIncrease => jumlah < maxJumlah;
  bool get canDecrease => jumlah > 1;
}

class Kategori {
  final int idKategori;
  final String namaKategori;
  final String? deskripsiKategori;

  Kategori({required this.idKategori, required this.namaKategori, this.deskripsiKategori});

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      idKategori: json['id_kategori'],
      namaKategori: json['nama_kategori'],
      deskripsiKategori: json['deskripsi_kategori'],
    );
  }
}