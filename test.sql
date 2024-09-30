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

alter table products
    alter column code type varchar(10);

select *
from products;

select *
from information_schema.columns
where table_name = 'products';

-- hapus data dan buat table baru
truncate products;

-- hapus table
-- drop table products;

insert into products (code, name, price)
values ('CO11', 'XIAOMI', 100000);

insert into products (code, name, price, qty)
values ('CO13', 'SAMSUNG', 100000, 20);

alter table products
    add primary key (code);

select *
from products;

select *
from products as p
where p.qty = 0;

create type products_enum_category as enum ('PHONE', 'LAPTOP', 'TOOLS');

alter table products
    drop column category;

alter table products
    add column category products_enum_category default 'PHONE';

update products
set description = 'SOMETHING WITH THIS THING'
where code = 'C013';

update products
set code = 'P001'
where qty = 20;

update products
set description = 'INI HP'
where code = 'P001';

select *
from products;

drop table products;

create table customers
(
    customer_id   serial       not null,
    customer_name varchar(100) not null,
    email         varchar(100) not null,
    created_at    timestamp default current_timestamp,
    primary key (customer_id),
    constraint unique_email unique (email) -- constraint unique untuk email
);

create table products
(
    product_id   serial primary key,
    product_name varchar(100)   not null,
    price        numeric(10, 2) not null,                 -- harga harus lebih dari 0
    stock        int            not null,                 -- stok tidak boleh negatif
    created_at   timestamp default current_timestamp,
    constraint unique_product_name unique (product_name), -- nama produk harus unik
    constraint check_stock check ( stock >= 0 ),
    constraint check_price check ( price > 0 )

);


create table wishlists
(
    wishlist_id serial not null, -- bisa juga: constraint pk_wishlist primary key (wishlist_id)
    customer_id int    not null, -- menghubungkan ke tabel customers
    product_id  int    not null, -- menghubungkan ke tabel products
    added_at    timestamp default current_timestamp,

    primary key (wishlist_id),
    constraint fk_customer foreign key (customer_id) references customers (customer_id) on delete cascade,
    constraint fk_product foreign key (product_id) references products (product_id) on delete cascade,
    constraint unique_wishlist unique (customer_id, product_id)
);

insert into customers (customer_name, email)
values ('Hilmi Akbar', 'hilmi.akbar@example.com'),
       ('Dewi Suryani', 'dewi.suryani@example.com'),
       ('Ahmad Fauzi', 'ahmad.fauzi@example.com'),
       ('Budi Santoso', 'budi.santoso@example.com'),
       ('Siti Aminah', 'siti.aminah@example.com');

select *
from customers;

insert into products (product_name, price, stock)
values ('Laptop Dell XPS', 15000000.00, 10),
       ('Smartphone Samsung Galaxy', 7000000.00, 25),
       ('Headphone Sony WH-1000XM4', 3500000.00, 15),
       ('Mouse Logitech MX Master', 1200000.00, 50),
       ('Monitor LG UltraWide', 5000000.00, 8);

select *
from products;

insert into wishlists (customer_id, product_id)
values (2, 3),
       (2, 2);

select *
from wishlists;

select count(w.wishlist_id) as total_wish, p.product_name, p.price
from wishlists as w
         join products p on p.product_id = w.product_id
group by p.product_name, p.price;

select count(w.product_id) as total_wish, p.product_name
from wishlists as w
         join products p on p.product_id = w.product_id
group by p.product_name;

select p.product_name, c.customer_name
from wishlists w
         join products p on p.product_id = w.product_id
         join customers c on w.customer_id = c.customer_id;

select p.product_name,
       count(w.wishlist_id)              as total_wish,
       string_agg(c.customer_name, ', ') as customer_names
from wishlists w
         join products p on p.product_id = w.product_id
         join customers c on w.customer_id = c.customer_id
group by p.product_name;

-- one to one
create table wallet
(
    id          serial not null,
    customer_id int    not null,
    balance     int    not null default 0,
    primary key (id),
    constraint wallet_customer_unique unique (customer_id),
    constraint balance_check check ( balance >= 0 ),
    constraint fk_customer foreign key (customer_id) references customers (customer_id)
);

insert into wallet (customer_id, balance)
values (1, 1000),
       (2, 2000),
       (3, 3000),
       (4, 4000),
       (5, 5000);

select *
from wallet;

select c.customer_name, w.balance
from customers as c
         join wallet w on w.customer_id = c.customer_id;


-- one category can have to many product
create table categories
(
    id   serial,
    name varchar(100) not null,
    primary key (id)
);

alter table products
    add column category_id int,
    add constraint fk_category foreign key (category_id) references categories (id);

insert into categories (name)
values ('ACCESSORIES');

select *
from categories;

select *
from products;

update products
set category_id = 3
where product_name ilike any (array ['%headp%', '%mouse%', '%monitor%'])

select p.product_name as "name product", c.name as "category name"
from products as p
         join categories c on p.category_id = c.id;


create table orders
(
    order_id   serial primary key,
    order_date timestamp default current_timestamp
);

create table order_products
(
    order_id   int,
    product_id int,
    quantity   int not null,
    primary key (order_id, product_id),
    foreign key (order_id) references orders (order_id),
    foreign key (product_id) references products (product_id)
);

insert into orders (order_id)
values (1); -- membuat pesanan 1
insert into order_products (order_id, product_id, quantity)
values (1, 1, 2); -- produk a 2 buah
insert into order_products (order_id, product_id, quantity)
values (1, 2, 1); -- produk b 1 buah

insert into orders (order_id)
values (2); -- membuat pesanan 2
insert into order_products (order_id, product_id, quantity)
values (2, 1, 1); -- produk a 1 buah
insert into order_products (order_id, product_id, quantity)
values (2, 3, 3); -- produk c 3 buah

select *
from orders;

select *
from order_products;

select p.product_name, c.name
from products p
         join categories c on p.category_id = c.id;

select p.product_name "product", o.order_date "date", o.order_id "id", op.quantity
from orders o
         join order_products op on o.order_id = op.order_id
         join products p on p.product_id = op.product_id;

insert into categories (name)
values ('NON-TECH');

insert into products (product_name, price, stock)
values ('ARCH LINUX', 10.00, 20),
       ('DEBIAN LINUX', 9.00, 10);

select *
from categories;

select p.product_name, c.name, p.price
from categories c
         inner join products p on c.id = p.category_id;

select p.product_name, c.name "category", p.price
from categories c
         left join products p on c.id = p.category_id;

select p.product_name, c.name "category", p.price
from categories c
         right join products p on c.id = p.category_id;

select p.product_name, c.name "category", p.price
from categories c
         full join products p on c.id = p.category_id;

select *
from products;

select p.product_name, c.name, p.price
from products p
         join categories c on p.category_id = c.id;


select avg(p.price)
from products p;

select *
from products p
where p.price > (select avg(p.price)
                 from products p);
select product_name
from products
where product_id in (select product_id
                     from order_products);

select product_id, count(order_id) as total_orders
from order_products
group by product_id;

select p.product_name, t.total_orders
from products p
         join (select product_id, count(order_id) as total_orders
               from order_products
               group by product_id) as t on p.product_id = t.product_id
where p.stock > 0;

select *
from order_products;

create table electronics
(
    product_id   serial primary key,
    product_name varchar(100)   not null,
    price        decimal(10, 2) not null
);

create table furniture
(
    product_id   serial primary key,
    product_name varchar(100)   not null,
    price        decimal(10, 2) not null
);

-- Isi data ke tabel electronics
insert into electronics (product_name, price)
values ('Laptop', 1500.00),
       ('Smartphone', 800.00),
       ('Headphones', 100.00),
       ('Tablet', 600.00);

-- Isi data ke tabel furniture
insert into furniture (product_name, price)
values ('Chair', 100.00),
       ('Table', 500.00),
       ('Couch', 1000.00),
       ('Laptop Desk', 1500.00);

insert into furniture (product_name, price)
values ('Couch', 1000.00);

select product_name, price
from electronics
union
select product_name, price
from furniture;

select *
from furniture;


select product_name
from furniture
intersect
select product_name
from electronics;

select product_name, price
from electronics
except
select product_name, price
from furniture;



