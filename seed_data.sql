-- =========================
-- SEED DATA KATEGORI
-- =========================
insert into kategori (nama_kategori, deskripsi_kategori)
values
  ('Camping', 'Peralatan camping'),
  ('Outdoor', 'Peralatan kegiatan luar ruangan');

-- =========================
-- SEED DATA ALAT
-- =========================
insert into alat (
  nama_alat, id_kategori, stok_alat, harga_alat,
  kondisi_alat, deskripsi, gambar
)
values
  ('Tenda Dome', 1, 10, 50000, 'baik', 'Tenda 4 orang', 'tenda.jpg'),
  ('Kompor Portable', 1, 5, 30000, 'baik', 'Kompor gas portable', 'kompor.jpg');

-- =========================
-- SEED DATA PEMINJAMAN
-- =========================
insert into peminjaman (
  id_user, tingkatan_kelas, id_alat,
  jumlah, tanggal_pinjam, batas_pengembalian
)
values
  (
    '6caca04c-2006-4e68-96bb-808f0319c96d',
    'XI TKR 1',
    1,
    2,
    '2026-01-10',
    '2026-01-13'
  );

-- =========================
-- SEED DETAIL PEMINJAMAN
-- =========================
insert into detail_peminjaman (id_peminjaman, id_alat, jumlah)
values
  (1, 1, 2);