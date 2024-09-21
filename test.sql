-- buat db
create database name_data;

-- select all db
select datname
from pg_database;

-- hapus db
drop database name_data;

-- buat db latihan
create database latihan;

-- pindah db klo di console `\c lathian` ga ada sql query buat pindah klo di dbclient

-- lihat current db table `\dt`
select tablename
from pg_tables
where schemaname = 'public';

-- membuat table
create table barang
(
    kode   int,
    name   varchar(100),
    harga  int,
    jumlah int
);

-- rubah
alter table barang
    add column description text;

alter table barang
    drop column "desc";

alter table barang
    rename column harga to price;

alter table barang
    rename column jumlah to qty;

alter table barang
    rename column kode to code;

alter table barang
    alter column price set not null,
    alter column name set not null,
    alter column code set not null,
    alter column qty set default 0;

alter table barang
    rename to products;

alter table products
add column created_at timestamp default current_timestamp;

select *
from products;

select *
from information_schema.columns
where table_name = 'products';

-- hapus data dan buat table baru
truncate products;

-- hapus table
-- drop table products;


