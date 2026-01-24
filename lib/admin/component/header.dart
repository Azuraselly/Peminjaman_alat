import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 50, 25, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF162D4A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Azura Aulia", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text("ADMIN", style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.w900, fontSize: 12)),
              ],
            ),
          ),
          _buildIcon(Icons.notifications_none),
          const SizedBox(width: 10),
          _buildIcon(Icons.logout),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: const Color(0xFF3B71B9),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.person, size: 35, color: Colors.white),
            ),
          ),
        ),
        const CircleAvatar(radius: 5, backgroundColor: Colors.green)
      ],
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}