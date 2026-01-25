import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_alat/admin/component/header.dart';
import 'package:inventory_alat/admin/component/navbar.dart';
import 'package:inventory_alat/admin/component/user/add_user_dialog.dart';
import 'package:inventory_alat/admin/component/user/user_card.dart';
import 'package:inventory_alat/admin/screen/user_detail_page.dart';
import 'package:inventory_alat/colors.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  bool _showNotification = false;
  String _notifMessage = "";
  int _currentIndex = 1; // Asumsi index 1 adalah Manajemen User

  // Data Master
  List<Map<String, dynamic>> _allUsers = [
    {
      "name": "Azura",
      "class": "XII TKR 1",
      "role": "Peminjam",
      "status": "Aktif",
      "isActive": true,
    },
    {
      "name": "Aulia",
      "class": "XII TKR 2",
      "role": "Petugas",
      "status": "Tidak Aktif",
      "isActive": false,
    },
  ];

  // Data Filter untuk Pencarian
  List<Map<String, dynamic>> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredUsers = _allUsers;
  }

  // --- LOGIKA CRUD & FITUR ---

  void _runFilter(String query) {
    setState(() {
      _filteredUsers = _allUsers
          .where(
            (user) => user["name"].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  // Panggil ini saat tombol edit ditekan
  void _editUser(int index) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AddUserDialog(initialData: _filteredUsers[index]),
    );

    if (result != null) {
      setState(() {
        // Cari nama user yang asli di master list dan update
        String oldName = _filteredUsers[index]['name'];
        int masterIndex = _allUsers.indexWhere((u) => u['name'] == oldName);
        _allUsers[masterIndex] = result;
        _runFilter(_searchController.text);
      });
      _triggerNotification("Data ${result['name']} berhasil diupdate");
    }
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

  void _deleteUser(String name) {
    setState(() {
      _allUsers.removeWhere((user) => user["name"] == name);
      _runFilter(_searchController.text);
    });
    _triggerNotification("Berhasil menghapus $name");
  }

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
        top: 50, // Sesuaikan dengan tinggi area biru header
        left: 25,
        right: 25,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(
                0.85,
              ), // Semi transparan sesuai gambar
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: _currentIndex,
        onItemTapped: (index) {
          if (index == _currentIndex) return;
          setState(() => _currentIndex = index);

          // Logika pindah halaman nyata
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 2) Navigator.pushReplacementNamed(context, '/settings');
        },
      ),
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
                        final result = await showDialog(
                          context: context,
                          builder: (_) => const AddUserDialog(),
                        );
                        if (result != null) {
                          setState(() {
                            _allUsers.add(result);
                            _runFilter("");
                          });
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
                      name: user['name'],
                      className: user['class'],
                      role: user['role'],
                      status: user['status'],
                      isActive: user['isActive'],
                      onDelete: () {
                        _showDeleteConfirmation(context, user['name'], () {
                          setState(() {
                            // Logika hapus data Anda
                            _allUsers.removeAt(index);
                            _runFilter(_searchController.text);
                          });
                          // Tampilkan notifikasi melayang PERSIS seperti gambar
                          _showTopNotification(
                            context,
                            "Menghapus 1 user: ${user['name']}",
                          );
                        });
                      },
                      onEdit: () => _editUser(index),
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
