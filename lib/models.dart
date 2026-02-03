// ============================================================================
// DATA MODELS FOR INVENTORY MANAGEMENT SYSTEM
// Matches PostgreSQL schema
// ============================================================================

import 'package:flutter/material.dart';

// ============================================================================
// USER MODEL
// ============================================================================

enum UserRole {
  admin,
  petugas,
  peminjam,
}

class AppUser {
  final String idUser; // uuid
  final String? username;
  final UserRole role;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? classLevel; // tingkatan_kelas

  AppUser({
    required this.idUser,
    this.username,
    required this.role,
    this.status = true,
    required this.createdAt,
    required this.updatedAt,
    this.classLevel,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      idUser: json['id_user'],
      username: json['username'],
      role: _parseRole(json['role']),
      status: json['status'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      classLevel: json['class'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'username': username,
      'role': role.name,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'class': classLevel,
    };
  }

  static UserRole _parseRole(String? role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'petugas':
        return UserRole.petugas;
      case 'peminjam':
        return UserRole.peminjam;
      default:
        return UserRole.peminjam;
    }
  }

  String get displayRole {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.petugas:
        return 'Petugas';
      case UserRole.peminjam:
        return 'Peminjam';
    }
  }
}

// ============================================================================
// KATEGORI MODEL
// ============================================================================

class Kategori {
  final int idKategori;
  final String namaKategori;
  final String? deskripsiKategori;
  final DateTime createdAt;

  Kategori({
    required this.idKategori,
    required this.namaKategori,
    this.deskripsiKategori,
    required this.createdAt,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      idKategori: json['id_kategori'],
      namaKategori: json['nama_kategori'],
      deskripsiKategori: json['deskripsi_kategori'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kategori': idKategori,
      'nama_kategori': namaKategori,
      'deskripsi_kategori': deskripsiKategori,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// ============================================================================
// ALAT MODEL
// ============================================================================

enum KondisiAlat {
  baik,
  rusakRingan,
  rusakBerat,
  hilang,
}

class Alat {
  final int idAlat;
  final String namaAlat;
  final int? idKategori;
  final Kategori? kategori; // Relasi dengan kategori
  final int stokAlat;
  final KondisiAlat kondisiAlat;
  final String? deskripsi;
  final String? gambar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Alat({
    required this.idAlat,
    required this.namaAlat,
    this.idKategori,
    this.kategori,
    required this.stokAlat,
    required this.kondisiAlat,
    this.deskripsi,
    this.gambar,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  bool get isAvailable => stokAlat > 0 && deletedAt == null;
  bool get isDeleted => deletedAt != null;

  factory Alat.fromJson(Map<String, dynamic> json) {
    return Alat(
      idAlat: json['id_alat'],
      namaAlat: json['nama_alat'],
      idKategori: json['id_kategori'],
      kategori: json['kategori'] != null 
          ? Kategori.fromJson(json['kategori']) 
          : null,
      stokAlat: json['stok_alat'],
      kondisiAlat: _parseKondisi(json['kondisi_alat']),
      deskripsi: json['deskripsi'],
      gambar: json['gambar'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null 
          ? DateTime.parse(json['deleted_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_alat': idAlat,
      'nama_alat': namaAlat,
      'id_kategori': idKategori,
      'stok_alat': stokAlat,
      'kondisi_alat': _kondisiToString(kondisiAlat),
      'deskripsi': deskripsi,
      'gambar': gambar,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  static KondisiAlat _parseKondisi(String? kondisi) {
    switch (kondisi) {
      case 'baik':
        return KondisiAlat.baik;
      case 'rusak ringan':
        return KondisiAlat.rusakRingan;
      case 'rusak berat':
        return KondisiAlat.rusakBerat;
      case 'hilang':
        return KondisiAlat.hilang;
      default:
        return KondisiAlat.baik;
    }
  }

  static String _kondisiToString(KondisiAlat kondisi) {
    switch (kondisi) {
      case KondisiAlat.baik:
        return 'baik';
      case KondisiAlat.rusakRingan:
        return 'rusak ringan';
      case KondisiAlat.rusakBerat:
        return 'rusak berat';
      case KondisiAlat.hilang:
        return 'hilang';
    }
  }

  String get kondisiDisplay {
    switch (kondisiAlat) {
      case KondisiAlat.baik:
        return 'Baik';
      case KondisiAlat.rusakRingan:
        return 'Rusak Ringan';
      case KondisiAlat.rusakBerat:
        return 'Rusak Berat';
      case KondisiAlat.hilang:
        return 'Hilang';
    }
  }

  Color get kondisiColor {
    switch (kondisiAlat) {
      case KondisiAlat.baik:
        return Colors.green;
      case KondisiAlat.rusakRingan:
        return Colors.orange;
      case KondisiAlat.rusakBerat:
        return Colors.red;
      case KondisiAlat.hilang:
        return Colors.grey;
    }
  }
}

// ============================================================================
// PEMINJAMAN MODEL
// ============================================================================

enum StatusPeminjaman {
  diajukan,
  disetujui,
  ditolak,
  dikembalikan,
}

class Peminjaman {
  final int idPeminjaman;
  final String? idUser;
  final AppUser? user; // Relasi dengan user
  final String? tingkatanKelas;
  final DateTime tanggalPinjam;
  final DateTime bataspengembalian;
  final StatusPeminjaman status;
  final String? disetujuiOleh;
  final AppUser? approver; // Relasi dengan user yang menyetujui
  final DateTime? waktuSetujui;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? idAlat;
  final Alat? alat; // Relasi dengan alat
  final int? jumlah;

  Peminjaman({
    required this.idPeminjaman,
    this.idUser,
    this.user,
    this.tingkatanKelas,
    required this.tanggalPinjam,
    required this.bataspengembalian,
    required this.status,
    this.disetujuiOleh,
    this.approver,
    this.waktuSetujui,
    required this.createdAt,
    required this.updatedAt,
    this.idAlat,
    this.alat,
    this.jumlah,
  });

  bool get isLate {
    if (status == StatusPeminjaman.dikembalikan) return false;
    return DateTime.now().isAfter(bataspengembalian);
  }

  bool get isPending => status == StatusPeminjaman.diajukan;
  bool get isApproved => status == StatusPeminjaman.disetujui;
  bool get isReturned => status == StatusPeminjaman.dikembalikan;

  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      idPeminjaman: json['id_peminjaman'],
      idUser: json['id_user'],
      user: json['user'] != null ? AppUser.fromJson(json['user']) : null,
      tingkatanKelas: json['tingkatan_kelas'],
      tanggalPinjam: DateTime.parse(json['tanggal_pinjam']),
      bataspengembalian: DateTime.parse(json['batas_pengembalian']),
      status: _parseStatus(json['status']),
      disetujuiOleh: json['disetujui_oleh'],
      approver: json['approver'] != null 
          ? AppUser.fromJson(json['approver']) 
          : null,
      waktuSetujui: json['waktu_setujui'] != null 
          ? DateTime.parse(json['waktu_setujui']) 
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      idAlat: json['id_alat'],
      alat: json['alat'] != null ? Alat.fromJson(json['alat']) : null,
      jumlah: json['jumlah'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_peminjaman': idPeminjaman,
      'id_user': idUser,
      'tingkatan_kelas': tingkatanKelas,
      'tanggal_pinjam': tanggalPinjam.toIso8601String().split('T')[0],
      'batas_pengembalian': bataspengembalian.toIso8601String().split('T')[0],
      'status': _statusToString(status),
      'disetujui_oleh': disetujuiOleh,
      'waktu_setujui': waktuSetujui?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'id_alat': idAlat,
      'jumlah': jumlah,
    };
  }

  static StatusPeminjaman _parseStatus(String? status) {
    switch (status) {
      case 'diajukan':
        return StatusPeminjaman.diajukan;
      case 'disetujui':
        return StatusPeminjaman.disetujui;
      case 'ditolak':
        return StatusPeminjaman.ditolak;
      case 'dikembalikan':
        return StatusPeminjaman.dikembalikan;
      default:
        return StatusPeminjaman.diajukan;
    }
  }

  static String _statusToString(StatusPeminjaman status) {
    return status.name;
  }

  String get statusDisplay {
    switch (status) {
      case StatusPeminjaman.diajukan:
        return 'Diajukan';
      case StatusPeminjaman.disetujui:
        return 'Disetujui';
      case StatusPeminjaman.ditolak:
        return 'Ditolak';
      case StatusPeminjaman.dikembalikan:
        return 'Dikembalikan';
    }
  }

  Color get statusColor {
    switch (status) {
      case StatusPeminjaman.diajukan:
        return Colors.blue;
      case StatusPeminjaman.disetujui:
        return Colors.green;
      case StatusPeminjaman.ditolak:
        return Colors.red;
      case StatusPeminjaman.dikembalikan:
        return Colors.grey;
    }
  }
}

// ============================================================================
// DETAIL PEMINJAMAN MODEL
// ============================================================================

class DetailPeminjaman {
  final int idDetailPeminjaman;
  final int? idPeminjaman;
  final int? idAlat;
  final Alat? alat; // Relasi dengan alat
  final int jumlah;
  final DateTime createdAt;
  final DateTime updatedAt;

  DetailPeminjaman({
    required this.idDetailPeminjaman,
    this.idPeminjaman,
    this.idAlat,
    this.alat,
    required this.jumlah,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DetailPeminjaman.fromJson(Map<String, dynamic> json) {
    return DetailPeminjaman(
      idDetailPeminjaman: json['id_detail_peminjaman'],
      idPeminjaman: json['id_peminjaman'],
      idAlat: json['id_alat'],
      alat: json['alat'] != null ? Alat.fromJson(json['alat']) : null,
      jumlah: json['jumlah'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_detail_peminjaman': idDetailPeminjaman,
      'id_peminjaman': idPeminjaman,
      'id_alat': idAlat,
      'jumlah': jumlah,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// ============================================================================
// PENGEMBALIAN MODEL
// ============================================================================

class Pengembalian {
  final int idPengembalian;
  final int? idPeminjaman;
  final Peminjaman? peminjaman; // Relasi dengan peminjaman
  final DateTime tanggalKembali;
  final String? kondisiSaatDikembalikan;
  final String? catatan;
  final String? diterimaOleh;
  final AppUser? receiver; // Relasi dengan user yang menerima
  final DateTime createdAt;

  Pengembalian({
    required this.idPengembalian,
    this.idPeminjaman,
    this.peminjaman,
    required this.tanggalKembali,
    this.kondisiSaatDikembalikan,
    this.catatan,
    this.diterimaOleh,
    this.receiver,
    required this.createdAt,
  });

  factory Pengembalian.fromJson(Map<String, dynamic> json) {
    return Pengembalian(
      idPengembalian: json['id_pengembalian'],
      idPeminjaman: json['id_peminjaman'],
      peminjaman: json['peminjaman'] != null 
          ? Peminjaman.fromJson(json['peminjaman']) 
          : null,
      tanggalKembali: DateTime.parse(json['tanggal_kembali']),
      kondisiSaatDikembalikan: json['kondisi_saat_dikembalikan'],
      catatan: json['catatan'],
      diterimaOleh: json['diterima_oleh'],
      receiver: json['receiver'] != null 
          ? AppUser.fromJson(json['receiver']) 
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pengembalian': idPengembalian,
      'id_peminjaman': idPeminjaman,
      'tanggal_kembali': tanggalKembali.toIso8601String().split('T')[0],
      'kondisi_saat_dikembalikan': kondisiSaatDikembalikan,
      'catatan': catatan,
      'diterima_oleh': diterimaOleh,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// ============================================================================
// LOG AKTIVITAS MODEL
// ============================================================================

class LogAktivitas {
  final int idAktivitas;
  final String? idUser;
  final AppUser? user; // Relasi dengan user
  final String aksi;
  final DateTime createdAt;

  LogAktivitas({
    required this.idAktivitas,
    this.idUser,
    this.user,
    required this.aksi,
    required this.createdAt,
  });

  factory LogAktivitas.fromJson(Map<String, dynamic> json) {
    return LogAktivitas(
      idAktivitas: json['id_aktifitas'],
      idUser: json['id_user'],
      user: json['user'] != null ? AppUser.fromJson(json['user']) : null,
      aksi: json['aksi'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_aktifitas': idAktivitas,
      'id_user': idUser,
      'aksi': aksi,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String getTimeAgo() {
    final difference = DateTime.now().difference(createdAt);
    
    if (difference.inSeconds < 60) {
      return 'BARU SAJA';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} MENIT LALU';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} JAM LALU';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} HARI LALU';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}

// ============================================================================
// DASHBOARD STATS MODEL
// ============================================================================

class DashboardStats {
  final int totalUsers;
  final int totalAlat;
  final int totalTransaksi;
  final int totalKategori;
  final int peminjamanAktif;
  final int peminjamanTerlambat;

  DashboardStats({
    required this.totalUsers,
    required this.totalAlat,
    required this.totalTransaksi,
    required this.totalKategori,
    required this.peminjamanAktif,
    required this.peminjamanTerlambat,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsers: json['total_users'] ?? 0,
      totalAlat: json['total_alat'] ?? 0,
      totalTransaksi: json['total_transaksi'] ?? 0,
      totalKategori: json['total_kategori'] ?? 0,
      peminjamanAktif: json['peminjaman_aktif'] ?? 0,
      peminjamanTerlambat: json['peminjaman_terlambat'] ?? 0,
    );
  }
}