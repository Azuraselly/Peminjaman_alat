import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/user/add_user_dialog.dart';
import 'package:inventory_alat/admin/component/user/user_card.dart';
import 'package:inventory_alat/admin/screen/admin/user/user_detail_page.dart';
import 'package:inventory_alat/colors.dart';
import 'package:inventory_alat/service/user_service.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  bool _showNotification = false;
  String _notifMessage = "";
  bool _isLoading = false;

  // Data Filter untuk Pencarian
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
<<<<<<< HEAD
      if (query.isEmpty) {
        _filteredUsers = _allUsers;
      } else {
        _filteredUsers = _allUsers
            .where(
              (user) =>
                  user['name'].toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _triggerNotification(String message) {
    setState(() {
      _notifMessage = message;
      _showNotification = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showNotification = false);
    });
  }
=======
      _filteredUsers = query.isEmpty
          ? _allUsers
          : _allUsers
              .where(
                (u) => u['name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  Future<void> _addUser() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const AddUserDialog(),
    );

    if (result != null) {
      await _userService.addUser(result);
      await _loadUsers();
    }
  }

  Future<void> _editUser(Map<String, dynamic> user) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AddUserDialog(initialData: user),
    );

    if (result != null) {
      await _userService.updateUser(user['id_user'], result);
      await _loadUsers();
    }
  }

                               
>>>>>>> 4fe59e9 (target 3)

  void _showDeleteConfirmation(
    BuildContext context,
    String name,
    VoidCallback onDelete,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
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
                "Yakin ingin menghapus?",
                style: GoogleFonts.poppins(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 25),
              // Garis Pemisah
              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
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
                  ), // Garis Vertikal
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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
        );
      },
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
    // Hilang otomatis setelah 2 detik
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

  // Update fungsi TAMBAH dengan validasi & loading
  void _addNewUser() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const AddUserDialog(),
    );

    if (result != null) {
      setState(() => _isLoading = true); // Mulai loading
      try {
        await _userService.addUser(result);
        await _loadData();
        _showTopNotification(
          context,
          "User ${result['name']} berhasil disimpan",
        );
      } catch (e) {
        _showErrorDialog(e.toString());
      } finally {
        setState(() => _isLoading = false); // Berhenti loading
      }
    }
  }

  // Update fungsi EDIT
  void _editUser(Map<String, dynamic> user) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AddUserDialog(initialData: user),
    );

    if (result != null) {
      setState(() => _isLoading = true);
      try {
        await _userService.updateUser(user['id_user'], result);
        await _loadData();
        _showTopNotification(context, "Data ${result['name']} diperbarui");
      } catch (e) {
        _showErrorDialog(e.toString());
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // Update fungsi HAPUS
  void _confirmDelete(Map<String, dynamic> user) {
    _showDeleteConfirmation(context, user['name'], () async {
      setState(() => _isLoading = true);
      try {
        await _userService.deleteUser(user['id_user'], user['name']);
        await _loadData();
        _showTopNotification(context, "Berhasil menghapus ${user['name']}");
      } catch (e) {
        _showErrorDialog(
          "Gagal menghapus: Mungkin user ini masih terkait dengan data lain.",
        );
      } finally {
        setState(() => _isLoading = false);
      }
    });
  }

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
                    _buildSquareBtn(
                      Icons.arrow_back,
                      () => Navigator.pop(context),
                    ),
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
                      () async {
                        final result = await showDialog<Map<String, dynamic>>(
                          context: context,
                          builder: (_) => const AddUserDialog(),
                        );
                        if (result != null) {
                          await _userService.addUser(result);
                          await _loadUsers();

                          _triggerNotification(
                            "User ${result['name']} ditambahkan",
                          );
                        }
                      },
                      color: const Color(0xFF3B71B9),
                      iconColor: Colors.white,
                    ),
                  ],
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
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
              // List User
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = _filteredUsers[index];
                    return UserCard(
  name: user['name'] ?? 'Tanpa Nama',
  role: user['role'] ?? '-',
  status: user['status'] == true ? 'Aktif' : 'Nonaktif',
  isActive: user['status'] ?? false,
  onDelete: () {
    _showDeleteConfirmation(
      context,
      user['name'] ?? 'User',
      () async {
        await _userService.deleteUser(user['id_user']);
        await _loadUsers();
        _showTopNotification(
          context,
          "User ${user['name']} dihapus",
        );
      },
    );
  },

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
          // Floating Notification
          if (_showNotification)
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: _buildNotifWidget(_notifMessage),
            ),
        ],
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: 1,
        onItemTapped: (index) {
          Navigator.pop(context);
        },
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

  Widget _buildNotifWidget(String msg) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF162D4A),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 15),
            Text(msg, style: GoogleFonts.poppins(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
