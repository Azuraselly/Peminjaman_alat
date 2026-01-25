import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiwayatPage extends StatelessWidget {
  final List<Map<String, dynamic>> dataRiwayat;
  const RiwayatPage({super.key, required this.dataRiwayat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Transaksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: dataRiwayat.length,
        itemBuilder: (context, i) => Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black12)),
          child: Row(
            children: [
              const CircleAvatar(backgroundColor: Color(0xFFE9EEF5), child: Icon(Icons.assignment_outlined, color: Color(0xFF1A314D))),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dataRiwayat[i]['nama'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(dataRiwayat[i]['tgl'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: dataRiwayat[i]['status'] == "Proses" ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(dataRiwayat[i]['status'], style: TextStyle(color: dataRiwayat[i]['status'] == "Proses" ? Colors.orange : Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}