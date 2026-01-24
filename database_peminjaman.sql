-- =====================================================
-- DATABASE EXPORT : SISTEM PEMINJAMAN ALAT
-- =====================================================

-- =========================
-- EXTENSION
-- =========================
create extension if not exists "uuid-ossp";

-- =========================
-- ENUM TYPES
-- =========================
create type role_enum as enum ('admin', 'petugas', 'peminjam');

create type kondisi_alat_enum as enum (
  'baik',
  'rusak ringan',
  'rusak berat',
  'hilang'
);

create type tingkatan_kelas_enum as enum (
  'X TKR 1', 'X TKR 2', 'X TKR 3', 'X TKR 4', 'X TKR 5', 'X TKR 6',
  'XI TKR 1', 'XI TKR 2', 'XI TKR 3', 'XI TKR 4', 'XI TKR 5', 'XI TKR 6',
  'XII TKR 1', 'XII TKR 2', 'XII TKR 3', 'XII TKR 4', 'XII TKR 5', 'XII TKR 6'
);

-- =========================
-- TABLE USERS
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
-- TABLE LOG AKTIFITAS
-- =========================
create table log_aktifitas (
  id_aktifitas serial primary key,
  id_user uuid references users(id_user),
  aksi text,
  created_at timestamp default now()
);

-- =========================
-- FUNCTION UPDATED_AT
-- =========================
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- =========================
-- TRIGGERS UPDATED_AT
-- =========================
create trigger trg_users_updated before update on users
for each row execute function set_updated_at();

create trigger trg_alat_updated before update on alat
for each row execute function set_updated_at();

create trigger trg_peminjaman_updated before update on peminjaman
for each row execute function set_updated_at();

create trigger trg_detail_peminjaman_updated before update on detail_peminjaman
for each row execute function set_updated_at();

-- =========================
-- FUNCTION GENERATE KODE
-- =========================
create or replace function generate_kode_peminjaman()
returns varchar language plpgsql as $$
begin
  return 'PJM-' || to_char(now(), 'YYYYMMDD-HH24MISS');
end;
$$;

-- =========================
-- TRIGGER AUTO KODE
-- =========================
create or replace function auto_kode_peminjaman()
returns trigger language plpgsql as $$
begin
  if new.kode_peminjaman is null then
    new.kode_peminjaman := generate_kode_peminjaman();
  end if;
  return new;
end;
$$;

create trigger trg_kode_peminjaman
before insert on peminjaman
for each row execute function auto_kode_peminjaman();

-- =========================
-- FUNCTION LOG PEMINJAMAN
-- =========================
create or replace function log_peminjaman()
returns trigger language plpgsql as $$
begin
  if tg_op = 'INSERT' then
    insert into log_aktifitas(id_user, aksi)
    values (new.id_user, 'Mengajukan peminjaman ' || new.kode_peminjaman);
  elsif tg_op = 'UPDATE' then
    insert into log_aktifitas(id_user, aksi)
    values (coalesce(new.disetujui_oleh, new.id_user),
            'Update status peminjaman ' || new.kode_peminjaman);
  end if;
  return new;
end;
$$;

create trigger trg_log_peminjaman
after insert or update on peminjaman
for each row execute function log_peminjaman();

-- =========================
-- FUNCTION STOK
-- =========================
create or replace function kurangi_stok_alat()
returns trigger language plpgsql as $$
begin
  update alat set stok_alat = stok_alat - new.jumlah
  where id_alat = new.id_alat;
  return new;
end;
$$;

create trigger trg_kurangi_stok
after insert on detail_peminjaman
for each row execute function kurangi_stok_alat();

create or replace function tambah_stok_alat()
returns trigger language plpgsql as $$
begin
  update alat
  set stok_alat = stok_alat + dp.jumlah
  from detail_peminjaman dp
  where dp.id_peminjaman = new.id_peminjaman
  and alat.id_alat = dp.id_alat;
  return new;
end;
$$;

create trigger trg_tambah_stok
after insert on pengembalian
for each row execute function tambah_stok_alat();

-- =========================
-- SEED DATA
-- =========================
insert into kategori (nama_kategori, deskripsi_kategori)
values ('Camping','Peralatan camping'),
       ('Outdoor','Peralatan luar ruangan');

insert into alat (nama_alat,id_kategori,stok_alat,harga_alat,kondisi_alat)
values ('Tenda Dome',1,10,50000,'baik'),
       ('Kompor Portable',1,5,30000,'baik');
