enum UserRole { admin, petugas, peminjam }

class LogAktivitas {
  final int idAktifitas;
  final String? idUser;
  final String aksi;
  final DateTime createdAt;
  final UserLog? user;

  LogAktivitas({
    required this.idAktifitas,
    this.idUser,
    required this.aksi,
    required this.createdAt,
    this.user,
  });

  factory LogAktivitas.fromJson(Map<String, dynamic> json) {
  return LogAktivitas(
    idAktifitas: json['id_aktifitas'] ?? 0, // Pastikan ada default value
    idUser: json['id_user']?.toString(),
    aksi: json['aksi'] ?? '-',
    // Pastikan created_at tidak null sebelum di-parse
    createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at']) 
        : DateTime.now(),
    user: json['users'] != null ? UserLog.fromJson(json['users']) : null,
  );
}

  String getTimeAgo() {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) return '${diff.inDays} hari yang lalu';
    if (diff.inHours > 0) return '${diff.inHours} jam yang lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes} menit yang lalu';
    return 'Baru saja';
  }
}

class UserLog {
  final String username;
  final UserRole role;

  UserLog({required this.username, required this.role});

  factory UserLog.fromJson(Map<String, dynamic> json) {
    return UserLog(
      username: json['username'] ?? 'User',
      role: _parseRole(json['role']),
    );
  }

  static UserRole _parseRole(String? role) {
    if (role == 'admin') return UserRole.admin;
    if (role == 'petugas') return UserRole.petugas;
    return UserRole.peminjam;
  }
}