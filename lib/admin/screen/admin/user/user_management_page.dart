import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/user/add_user_dialog.dart';
import 'package:inventory_alat/admin/component/user/user_card.dart';
import 'package:inventory_alat/admin/screen/admin/user/user_detail_page.dart';
import 'package:inventory_alat/service/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  bool _showNotification = false;
  String _notifMessage = "";
  bool _isLoading = false;

  List<Map<String, dynamic>> _filteredUsers = [];
  List<Map<String, dynamic>> _allUsers = [];
  final TextEditingController _searchController = TextEditingController();

  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final users = await _userService.getAllUsers();
      setState(() {
        _allUsers = users;
        _filteredUsers = users;
      });
    } catch (e) {
      _showErrorDialog("Gagal memuat data user: ${e.toString()}");
    }
  }

  void _runFilter(String query) {
    setState(() {
      _filteredUsers = query.isEmpty
          ? _allUsers
          : _allUsers
              .where(
                (u) => u['username']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  // ==========================
  // TAMBAH USER (SignUp + Insert)
  // ==========================
  void _addNewUser() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const AddUserDialog(),
    );

    if (result != null) {
      setState(() => _isLoading = true);

      try {
        // 1️⃣ Signup user di Supabase Auth
        final response = await Supabase.instance.client.auth.signUp(
          email: result['email'],
          password: result['password'],
        );

        final userId = response.user?.id;

        if (userId != null) {
          // 2️⃣ Insert ke tabel users
          await Supabase.instance.client.from('users').insert({
            'id_user': userId,
            'username': result['username'],
            'role': result['role'] ?? 'peminjam',
            'status': true,
            'class': result['class'] ?? '-',
          });

          // 3️⃣ Refresh data
          await _loadData();

          // 4️⃣ Notifikasi sukses
          _showTopNotification(
            context,
            "User ${result['username']} berhasil disimpan",
          );
        } else {
          _showErrorDialog("Gagal membuat user, id dari auth kosong.");
        }
      } catch (e) {
        _showErrorDialog("Error adding user: ${e.toString()}");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // ==========================
  // EDIT USER
  // ==========================
  void _editUser(Map<String, dynamic> user) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AddUserDialog(initialData: user),
    );

    if (result != null) {
      setState(() => _isLoading = true);
      try {
        // Tambahkan id_user untuk edit
        result['id_user'] = user['id_user'];
        await _userService.addUser(result); // Gunakan addUser yang sama karena sudah handle edit
        await _loadData();
        _showTopNotification(context, "Data ${result['username']} diperbarui");
      } catch (e) {
        _showErrorDialog("Gagal mengupdate user: ${e.toString()}");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // ==========================
  // HAPUS USER
  // ==========================
  void _confirmDelete(Map<String, dynamic> user) {
    _showDeleteConfirmation(context, user['username'], () async {
      setState(() => _isLoading = true);
      try {
        await _userService.deleteUser(user['id_user']);
        await _loadData();
        _showTopNotification(context, "Berhasil menghapus ${user['username']}");
      } catch (e) {
        _showErrorDialog(
          "Gagal menghapus: Mungkin user ini masih terkait dengan data lain.",
        );
      } finally {
        setState(() => _isLoading = false);
      }
    });
  }

  void _showDeleteConfirmation(
      BuildContext context, String name, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            Text(
              "Konfirmasi Hapus",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Yakin ingin menghapus $name?",
              style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 25),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      "Batal",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF3B71B9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: const Color(0xFFEEEEEE),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onDelete();
                    },
                    child: Text(
                      "Hapus",
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTopNotification(BuildContext context, String message) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        left: 25,
        right: 25,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Admin 01",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Terjadi Kesalahan"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ==========================
  // BUILD
  // ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          Column(
            children: [
              const CustomHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
                child: Row(
                  children: [
                    _buildSquareBtn(Icons.arrow_back, () => Navigator.pop(context)),
                    const SizedBox(width: 15),
                    Text(
                      "Manajemen User",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    _buildSquareBtn(
                      Icons.add,
                      _addNewUser,
                      color: const Color(0xFF3B71B9),
                      iconColor: Colors.white,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: _runFilter,
                  decoration: InputDecoration(
                    hintText: "Cari nama user...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          return UserCard(
                            name: user['username'] ?? 'Tanpa Nama',
                            role: user['role'] ?? '-',
                            status: user['status'] == true ? 'Aktif' : 'Nonaktif',
                            className: user['class'],
                            isActive: user['status'] ?? false,
                            onDelete: () => _confirmDelete(user),
                            onEdit: () => _editUser(user),
                            onTapProfile: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetailPage(userData: user),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 1,
        onItemTapped: (index) => Navigator.pop(context),
      ),
    );
  }

  Widget _buildSquareBtn(
    IconData icon,
    VoidCallback onTap, {
    Color color = const Color(0xFFE8EEF5),
    Color iconColor = Colors.black87,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}
