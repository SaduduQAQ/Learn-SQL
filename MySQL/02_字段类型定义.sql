-- 02 | 字段： 这么多字段类型，该怎么定义？
use demo;
create table demo.goods_master
(
    barcode     text,
    goods_name  text,
    price       double,
    item_number int primary key auto_increment
);

-- 插入数据
insert into demo.goods_master(barcode, goods_name, price)
values ('0001', '书', 0.47);-- 第一条
insert into demo.goods_master (barcode, goods_name, price)
values ('0001', '书', 0.47);-- 第二条
insert into demo.goods_master (barcode, goods_name, price)
values ('0002', '笔', 0.44);-- 第三条
insert into demo.goods_master (barcode, goods_name, price)
values ('0002', '胶水', 0.19);

select *
from demo.goods_master;

-- 聚合函数
select sum(price)
from demo.goods_master;

-- 搜索价格总和为1.1的
select goods_name, sum(price)
from demo.goods_master
group by goods_name
having sum(price) = 1.1;

-- 修改字段类型
alter table demo.goods_master
    modify column price DECIMAL(5, 2);