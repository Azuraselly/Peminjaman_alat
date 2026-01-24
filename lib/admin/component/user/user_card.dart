import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String className;
  final String role;
  final String status;
  final bool isActive;
  final VoidCallback onDelete;
  final VoidCallback onTapProfile;

  const UserCard({
    super.key,
    required this.name,
    required this.className,
    required this.role,
    required this.status,
    this.isActive = true,
    required this.onDelete,
    required this.onTapProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFFE8EEF5),
                child: Text(name.substring(0, 2).toUpperCase(), 
                    style: const TextStyle(color: Color(0xFF3B71B9), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(className, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn("ROLE", role, Colors.black),
              _infoColumn("STATUS", status, isActive ? Colors.green : Colors.red),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onTapProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEEEEEE),
                    foregroundColor: Colors.black54,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("LIHAT PROFIL"),
                ),
              ),
              const SizedBox(width: 10),
              _actionIcon(Icons.edit_outlined, Colors.blue),
              const SizedBox(width: 10),
              _actionIcon(Icons.delete_outline, Colors.red),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value, Color valColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valColor)),
      ],
    );
  }

  Widget _actionIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}