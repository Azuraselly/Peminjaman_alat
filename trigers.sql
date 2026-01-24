-- =========================================
-- FUNCTION TRIGGER: AUTO UPDATE TIMESTAMP
-- =========================================
create or replace function set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;


-- =========================================
-- TRIGGER: UPDATED_AT (USERS)
-- =========================================
create trigger trg_users_updated
before update on users
for each row
execute function set_updated_at();


-- =========================================
-- TRIGGER: UPDATED_AT (ALAT)
-- =========================================
create trigger trg_alat_updated
before update on alat
for each row
execute function set_updated_at();


-- =========================================
-- TRIGGER: UPDATED_AT (PEMINJAMAN)
-- =========================================
create trigger trg_peminjaman_updated
before update on peminjaman
for each row
execute function set_updated_at();


-- =========================================
-- TRIGGER: UPDATED_AT (DETAIL PEMINJAMAN)
-- =========================================
create trigger trg_detail_peminjaman_updated
before update on detail_peminjaman
for each row
execute function set_updated_at();


-- =========================================
-- FUNCTION TRIGGER: AUTO GENERATE KODE PEMINJAMAN
-- =========================================
create or replace function auto_kode_peminjaman()
returns trigger
language plpgsql
as $$
begin
  if new.kode_peminjaman is null then
    new.kode_peminjaman := generate_kode_peminjaman();
  end if;
  return new;
end;
$$;


-- =========================================
-- TRIGGER: AUTO KODE PEMINJAMAN
-- =========================================
create trigger trg_kode_peminjaman
before insert on peminjaman
for each row
execute function auto_kode_peminjaman();


-- =========================================
-- FUNCTION TRIGGER: LOG AKTIVITAS OTOMATIS
-- =========================================
create or replace function log_peminjaman()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'INSERT' then
    insert into log_aktifitas(id_user, aksi)
    values (new.id_user, 'Mengajukan peminjaman kode ' || new.kode_peminjaman);

  elsif tg_op = 'UPDATE' then
    insert into log_aktifitas(id_user, aksi)
    values (
      coalesce(new.disetujui_oleh, new.id_user),
      'Update status peminjaman kode ' || new.kode_peminjaman ||
      ' menjadi ' || new.status
    );
  end if;

  return new;
end;
$$;


-- =========================================
-- TRIGGER: LOG PEMINJAMAN
-- =========================================
create trigger trg_log_peminjaman
after insert or update on peminjaman
for each row
execute function log_peminjaman();


-- =========================================
-- FUNCTION TRIGGER: KURANGI STOK ALAT
-- =========================================
create or replace function kurangi_stok_alat()
returns trigger
language plpgsql
as $$
begin
  update alat
  set stok_alat = stok_alat - new.jumlah
  where id_alat = new.id_alat;

  return new;
end;
$$;


-- =========================================
-- TRIGGER: KURANGI STOK SAAT DETAIL PEMINJAMAN
-- =========================================
create trigger trg_kurangi_stok
after insert on detail_peminjaman
for each row
execute function kurangi_stok_alat();


-- =========================================
-- FUNCTION TRIGGER: TAMBAH STOK SAAT PENGEMBALIAN
-- =========================================
create or replace function tambah_stok_alat()
returns trigger
language plpgsql
as $$
begin
  update alat
  set stok_alat = stok_alat + dp.jumlah
  from detail_peminjaman dp
  where dp.id_peminjaman = new.id_peminjaman
    and alat.id_alat = dp.id_alat;

  return new;
end;
$$;


-- =========================================
-- TRIGGER: TAMBAH STOK SAAT PENGEMBALIAN
-- =========================================
create trigger trg_tambah_stok
after insert on pengembalian
for each row
execute function tambah_stok_alat();
