# where 与 having 有什么区别
# where 是直接对表中的字段进行限定， 来筛选结果
# having 需要跟 group by 一起使用, 通过对分组字段或分组计算函数进行限定， 来筛选结果
create table demo.goods_master_where_having
(
    item_number   int,
    barcode       int,
    goods_name    varchar(20),
    specification varchar(20),
    unit          varchar(20),
    sales_price   decimal(10, 2)
);
create table demo.transaction_details_where_having
(
    transaction_id int,
    item_number    int,
    quantity       decimal(10, 2),
    price          decimal(10, 2),
    sales_value    decimal(10, 2)
);
alter table
    demo.goods_master_where_having
    modify
        column barcode varchar(20);
insert into demo.goods_master_where_having
values (1, 0001, '书', '三联版', '本', 89.00),
       (2, 0002, '笔', '白', '支', 5.00);
insert into demo.transaction_details_where_having
values (1, 1, 1.000, 89.00, 89.00),
       (1, 2, 2.000, 5.00, 10.00),
       (2, 1, 2.000, 89.00, 178.00),
       (3, 2, 10.000, 5.00, 50.00);

select *
from demo.goods_master_where_having;
select *
from demo.transaction_details_where_having;

# where 和 group_by having
select distinct b.goods_name
from demo.transaction_details_where_having as a
         join demo.goods_master_where_having as b
              on (a.item_number = b.item_number)
where a.sales_value > 50;

select b.goods_name
from demo.transaction_details_where_having as a
         join demo.goods_master_where_having as b
              on (a.item_number = b.item_number)
group by b.goods_name
having max(a.sales_value) > 50;

# Group By
create table demo.transaction_head_where_having
(
    transaction_id int,
    transaction_no varchar(20),
    operator_id    int,
    trans_date     datetime
);

create table demo.operator_where_having
(
    operator_id   int,
    branch_id     int,
    work_no       varchar(20),
    operator_name varchar(20),
    phone         varchar(20),
    address       varchar(20),
    pid           varchar(20),
    duty          varchar(20)
);

insert into demo.transaction_head_where_having
values (1, '0120201201000001', 1, '2020-12-10'),
       (2, '0120201202000001', 2, '2020-12-11'),
       (3, '0120201202000002', 2, '2020-12-12');

insert into demo.operator_where_having
values (1, 1, '001', '张静', '18612345678', '北京', '110392197501012332', '店长'),
       (2, 1, '002', '李强', '13312345678', '北京', '110222199501012332', '收银员');

select
a.trans_date, c.operator_name, d.goods_name, b.quantity, b.price, b.sales_value
from demo.transaction_head_where_having as a
join demo.transaction_details_where_having as b on (a.transaction_id = b.transaction_id)
join demo.operator_where_having as c on (a.operator_id = c.operator_id)
join demo.goods_master_where_having as d on (b.item_number = d.item_number);

select a.trans_date, sum(b.quantity), sum(b.sales_value)
from demo.transaction_head_where_having as a
join demo.transaction_details_where_having as b on (a.transaction_id = b.transaction_id)
group by a.trans_date;

select a.trans_date, c.operator_name, SUM(b.quantity), SUM(b.sales_value)
from demo.transaction_head_where_having as a
join demo.transaction_details_where_having as b on (a.transaction_id = b.transaction_id)
join demo.operator_where_having as c on (a.operator_id = c.operator_id)
group by a.trans_date, c.operator_name;

# 查询一下哪个收银员、在哪天卖了2单商品。
select a.trans_date, c.operator_name
from demo.transaction_head_where_having as a
join demo.transaction_details_where_having as b on (a.transaction_id = b.transaction_id)
join demo.operator_where_having as c on (a.operator_id = c.operator_id)
group by a.trans_date, c.operator_name
having COUNT(*) = 2;

