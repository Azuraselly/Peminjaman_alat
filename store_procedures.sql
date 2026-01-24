-- ==============================
-- FUNCTION: GENERATE KODE PEMINJAMAN
-- ==============================
create or replace function generate_kode_peminjaman()
returns varchar as $$
declare
  kode varchar;
begin
  kode := 'PJM-' || to_char(now(), 'YYYYMMDD-HH24MISS');
  return kode;
end;
$$ language plpgsql;


-- ==============================
-- FUNCTION: CEK STATUS PEMINJAMAN
-- ==============================
create or replace function cek_status_peminjaman(p_id integer)
returns varchar as $$
declare
  v_status varchar;
begin
  select status
  into v_status
  from peminjaman
  where id_peminjaman = p_id;

  return v_status;
end;
$$ language plpgsql;


-- ==============================
-- FUNCTION: HITUNG DENDA
-- ==============================
create or replace function hitung_denda(
  p_batas date,
  p_kembali date
)
returns numeric as $$
declare
  terlambat integer;
  denda numeric := 0;
begin
  if p_kembali > p_batas then
    terlambat := p_kembali - p_batas;
    denda := terlambat * 5000;
  end if;

  return denda;
end;
$$ language plpgsql;


-- ==============================
-- PROCEDURE: APPROVE PEMINJAMAN
-- ==============================
create or replace procedure approve_peminjaman(
  p_id_peminjaman integer,
  p_admin uuid
)
language plpgsql
as $$
begin
  update peminjaman
  set status = 'disetujui',
      disetujui_oleh = p_admin,
      waktu_setujui = now(),
      updated_at = now()
  where id_peminjaman = p_id_peminjaman;

  insert into log_aktifitas(id_user, aksi)
  values (p_admin, 'Menyetujui peminjaman ID ' || p_id_peminjaman);

  commit;
exception
  when others then
    rollback;
    raise;
end;
$$;


-- ==============================
-- PROCEDURE: TOLAK PEMINJAMAN
-- ==============================
create or replace procedure tolak_peminjaman(
  p_id_peminjaman integer,
  p_admin uuid
)
language plpgsql
as $$
begin
  update peminjaman
  set status = 'ditolak',
      disetujui_oleh = p_admin,
      updated_at = now()
  where id_peminjaman = p_id_peminjaman;

  insert into log_aktifitas(id_user, aksi)
  values (p_admin, 'Menolak peminjaman ID ' || p_id_peminjaman);

  commit;
exception
  when others then
    rollback;
    raise;
end;
$$;


-- ==============================
-- PROCEDURE: PENGEMBALIAN + DENDA
-- ==============================
create or replace procedure pengembalian_alat(
  p_id_peminjaman integer,
  p_tanggal_kembali date,
  p_kondisi varchar,
  p_catatan text,
  p_petugas uuid
)
language plpgsql
as $$
declare
  v_batas date;
  v_denda numeric;
begin
  select batas_pengembalian
  into v_batas
  from peminjaman
  where id_peminjaman = p_id_peminjaman;

  v_denda := hitung_denda(v_batas, p_tanggal_kembali);

  insert into pengembalian(
    id_peminjaman,
    tanggal_kembali,
    kondisi_saat_dikembalikan,
    catatan,
    diterima_oleh
  )
  values (
    p_id_peminjaman,
    p_tanggal_kembali,
    p_kondisi,
    p_catatan || ' | Denda: Rp' || v_denda,
    p_petugas
  );

  update peminjaman
  set status = 'dikembalikan',
      updated_at = now()
  where id_peminjaman = p_id_peminjaman;

  insert into log_aktifitas(id_user, aksi)
  values (p_petugas, 'Pengembalian peminjaman ID ' || p_id_peminjaman);

  commit;
exception
  when others then
    rollback;
    raise;
end;
$$;


-- ==============================
-- FUNCTION: STATISTIK PEMINJAMAN
-- ==============================
create or replace function get_statistik_peminjaman()
returns table(
  total integer,
  disetujui integer,
  ditolak integer,
  dikembalikan integer
) as $$
begin
  return query
  select
    count(*) as total,
    count(*) filter (where status = 'disetujui'),
    count(*) filter (where status = 'ditolak'),
    count(*) filter (where status = 'dikembalikan')
  from peminjaman;
end;
$$ language plpgsql;


-- ==============================
-- FUNCTION: DETAIL PEMINJAMAN + ALAT
-- ==============================
create or replace function get_detail_peminjaman(p_id integer)
returns table(
  id_peminjaman integer,
  nama_alat varchar,
  jumlah integer
) as $$
begin
  return query
  select
    dp.id_peminjaman,
    a.nama_alat,
    dp.jumlah
  from detail_peminjaman dp
  join alat a on a.id_alat = dp.id_alat
  where dp.id_peminjaman = p_id;
end;
$$ language plpgsql;
