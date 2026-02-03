import 'dart:ui';
import 'package:flutter/material.dart';

class Alat {
  final int idAlat;
  final String namaAlat;
  final String? idKategori;
  final String? namaKategori;
  final int stokAlat;
  final String kondisiAlat;
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

  // Getter untuk kompatibilitas dengan kode lama
  int get id => idAlat;
  String get nama => namaAlat;
  int get stok => stokAlat;
  String get kategori => namaKategori ?? 'Umum';

  factory Alat.fromJson(Map<String, dynamic> json) {
    return Alat(
      idAlat: json['id_alat'],
      namaAlat: json['nama_alat'],
      idKategori: json['id_kategori'],
      namaKategori: json['kategori']?['nama_kategori'],
      stokAlat: json['stok_alat'],
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

class KeranjangItem {
  final Alat alat;
  int jumlah;

  KeranjangItem({
    required this.alat,
    this.jumlah = 1,
  });

  // Total stok yang tersedia
  int get maxJumlah => alat.stokAlat;
  
  // Cek apakah bisa tambah
  bool get canIncrease => jumlah < maxJumlah;
  
  // Cek apakah bisa kurang
  bool get canDecrease => jumlah > 1;

  get userClass => null;
}

class Kategori {
  final int idKategori;
  final String namaKategori;
  final String? deskripsiKategori;

  Kategori({
    required this.idKategori,
    required this.namaKategori,
    this.deskripsiKategori,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      idKategori: json['id_kategori'],
      namaKategori: json['nama_kategori'],
      deskripsiKategori: json['deskripsi_kategori'],
    );
  }
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

  PeminjamanItem({
    this.idPeminjaman,
    required this.namaAlat,
    this.gambarAlat,
    required this.tanggalPinjam,
    required this.batasPengembalian,
    required this.status,
    required this.jumlah,
    this.kategori,
  });

  factory PeminjamanItem.fromMap(Map<String, dynamic> json)
 {
    return PeminjamanItem(
      idPeminjaman: json['id_peminjaman'],
      namaAlat: json['alat']?['nama_alat'] ?? 'Unknown',
      gambarAlat: json['alat']?['gambar'],
      tanggalPinjam: DateTime.parse(json['tanggal_pinjam']),
      batasPengembalian: DateTime.parse(json['batas_pengembalian']),
      status: json['status'],
      jumlah: json['jumlah'] ?? 1,
      kategori: json['alat']?['kategori']?['nama_kategori'],
    );
  }

  String get statusDisplay {
    switch (status) {
      case 'diajukan':
        return 'Proses';
      case 'disetujui':
        return 'Disetujui';
      case 'ditolak':
        return 'Ditolak';
      case 'dikembalikan':
        return 'Kembali';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'diajukan':
        return Colors.orange;
      case 'disetujui':
        return Colors.blue;
      case 'ditolak':
        return Colors.red;
      case 'dikembalikan':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  bool get isLate {
    if (status == 'dikembalikan') return false;
    return DateTime.now().isAfter(batasPengembalian);
  }
}