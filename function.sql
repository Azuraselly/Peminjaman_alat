-- =========================================
-- FUNCTION: GENERATE KODE PEMINJAMAN
-- =========================================
create or replace function generate_kode_peminjaman()
returns varchar
language plpgsql
as $$
declare
  kode varchar;
begin
  kode := 'PJM-' || to_char(now(), 'YYYYMMDD-HH24MISS');
  return kode;
end;
$$;


-- =========================================
-- FUNCTION: CEK STATUS PEMINJAMAN
-- =========================================
create or replace function cek_status_peminjaman(p_id_peminjaman integer)
returns varchar
language plpgsql
as $$
declare
  v_status varchar;
begin
  select status
  into v_status
  from peminjaman
  where id_peminjaman = p_id_peminjaman;

  return v_status;
end;
$$;


-- =========================================
-- FUNCTION: HITUNG DENDA
-- =========================================
create or replace function hitung_denda(
  p_batas_pengembalian date,
  p_tanggal_kembali date
)
returns numeric
language plpgsql
as $$
declare
  hari_terlambat integer;
  total_denda numeric := 0;
begin
  if p_tanggal_kembali > p_batas_pengembalian then
    hari_terlambat := p_tanggal_kembali - p_batas_pengembalian;
    total_denda := hari_terlambat * 5000;
  end if;

  return total_denda;
end;
$$;


-- =========================================
-- FUNCTION: GET STATISTIK PEMINJAMAN
-- =========================================
create or replace function get_statistik_peminjaman()
returns table (
  total_peminjaman integer,
  total_diajukan integer,
  total_disetujui integer,
  total_ditolak integer,
  total_dikembalikan integer
)
language plpgsql
as $$
begin
  return query
  select
    count(*) as total_peminjaman,
    count(*) filter (where status = 'diajukan'),
    count(*) filter (where status = 'disetujui'),
    count(*) filter (where status = 'ditolak'),
    count(*) filter (where status = 'dikembalikan')
  from peminjaman;
end;
$$;


-- =========================================
-- FUNCTION: GET DETAIL PEMINJAMAN + ALAT
-- =========================================
create or replace function get_detail_peminjaman(p_id_peminjaman integer)
returns table (
  id_peminjaman integer,
  nama_alat varchar,
  jumlah integer,
  harga_alat numeric,
  subtotal numeric
)
language plpgsql
as $$
begin
  return query
  select
    p.id_peminjaman,
    a.nama_alat,
    dp.jumlah,
    a.harga_alat,
    (dp.jumlah * a.harga_alat) as subtotal
  from peminjaman p
  join detail_peminjaman dp on dp.id_peminjaman = p.id_peminjaman
  join alat a on a.id_alat = dp.id_alat
  where p.id_peminjaman = p_id_peminjaman;
end;
$$;


-- =========================================
-- FUNCTION: CEK STOK ALAT
-- =========================================
create or replace function cek_stok_alat(
  p_id_alat integer,
  p_jumlah integer
)
returns boolean
language plpgsql
as $$
declare
  stok integer;
begin
  select stok_alat
  into stok
  from alat
  where id_alat = p_id_alat;

  if stok >= p_jumlah then
    return true;
  else
    return false;
  end if;
end;
$$;
