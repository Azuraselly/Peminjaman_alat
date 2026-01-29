class UserModel {
  final String id;
  final String name;
  final String kelas;
  final String role;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.kelas,
    required this.role,
    required this.isActive,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id_user'],
      name: map['username'],
      kelas: map['kelas'],
      role: map['role'],
      isActive: map['status'] ?? true,
    );
  }

  Map<String, dynamic> toInsert() {
    return {
      'username': name,
      'kelas': kelas,
      'role': role,
      'status': isActive,
    };
  }
}
