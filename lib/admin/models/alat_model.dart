import 'kategori_model.dart';

class AlatModel {
  final int idAlat;
  final String namaAlat;
  final int stokAlat;
  final String kondisiAlat;
  final String deskripsi;
  final String? gambar;
  final String? createdAt;
  final KategoriModel kategori;

  AlatModel({
    required this.idAlat,
    required this.namaAlat,
    required this.stokAlat,
    required this.kondisiAlat,
    required this.deskripsi,
    required this.kategori,
    this.gambar,
    this.createdAt,
  });

  factory AlatModel.fromJson(Map<String, dynamic> json) {
    return AlatModel(
      idAlat: json['id_alat'] ?? 0,
      namaAlat: json['nama_alat'] ?? '',
      stokAlat: json['stok_alat'] ?? 0,
      kondisiAlat: json['kondisi_alat'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      gambar: json['gambar'],
      createdAt: json['created_at'],
      kategori: json['kategori'] != null
          ? KategoriModel.fromJson(json['kategori'])
          : KategoriModel(idKategori: 0, namaKategori: '-'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_alat': idAlat,
      'nama_alat': namaAlat,
      'stok_alat': stokAlat,
      'kondisi_alat': kondisiAlat,
      'deskripsi': deskripsi,
      'gambar': gambar,
      'created_at': createdAt,
      'kategori': kategori.toJson(),
    };
  }

  void operator [](String other) {}
}
