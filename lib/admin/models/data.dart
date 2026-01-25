class UserModel {
  final String id;
  String name;
  String kelas;
  String role;
  bool isActive;
  int totalPinjam;

  UserModel({
    required this.id,
    required this.name,
    required this.kelas,
    required this.role,
    this.isActive = true,
    this.totalPinjam = 0,
  });
}
