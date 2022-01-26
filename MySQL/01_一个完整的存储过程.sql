-- 01 | 存储：一个完整的数据存储过程是怎样的？
create database demo;
show databases;
create table demo.test
(
    barcode      text,
    goods_name text,
    price        int
);

describe demo.test;

use demo;
show tables;
alter table demo.test add column item_number int primary key auto_increment;
insert into demo.test (barcode, goods_name, price) values ('0001', '本', 3);