-- =========================
-- EXTENSION
-- =========================
create extension if not exists "uuid-ossp";

-- =========================
-- TABLE USERS (PROFILE)
-- =========================
create table users (
  id_user uuid primary key references auth.users(id) on delete cascade,
  username varchar(50),
  role role_enum not null,
  status boolean default true,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

-- =========================
-- TABLE KATEGORI
-- =========================
create table kategori (
  id_kategori serial primary key,
  nama_kategori varchar(100) not null,
  deskripsi_kategori text,
  created_at timestamp default now()
);

-- =========================
-- TABLE ALAT
-- =========================
create table alat (
  id_alat serial primary key,
  nama_alat varchar(100) not null,
  id_kategori integer references kategori(id_kategori),
  stok_alat integer not null,
  harga_alat numeric(12,2),
  kondisi_alat kondisi_alat_enum,
  deskripsi text,
  gambar text,
  created_at timestamp default now(),
  updated_at timestamp default now(),
  deleted_at timestamp
);

-- =========================
-- TABLE PEMINJAMAN
-- =========================
create table peminjaman (
  id_peminjaman serial primary key,
  kode_peminjaman varchar(30) unique,
  id_user uuid references users(id_user),
  tingkatan_kelas tingkatan_kelas_enum,
  id_alat integer references alat(id_alat),
  jumlah integer not null,
  tanggal_pinjam date not null,
  batas_pengembalian date not null,
  status varchar(20)
    check (status in ('diajukan','disetujui','ditolak','dikembalikan'))
    default 'diajukan',
  disetujui_oleh uuid references users(id_user),
  waktu_setujui timestamp,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

-- =========================
-- TABLE DETAIL PEMINJAMAN
-- =========================
create table detail_peminjaman (
  id_detail_peminjaman serial primary key,
  id_peminjaman integer references peminjaman(id_peminjaman) on delete cascade,
  id_alat integer references alat(id_alat),
  jumlah integer not null,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

-- =========================
-- TABLE PENGEMBALIAN
-- =========================
create table pengembalian (
  id_pengembalian serial primary key,
  id_peminjaman integer references peminjaman(id_peminjaman),
  tanggal_kembali date not null,
  kondisi_saat_dikembalikan varchar(50),
  catatan text,
  diterima_oleh uuid references users(id_user),
  created_at timestamp default now()
);

-- =========================
-- TABLE LOG AKTIVITAS
-- =========================
create table log_aktifitas (
  id_aktifitas serial primary key,
  id_user uuid references users(id_user),
  aksi text,
  created_at timestamp default now()
);
