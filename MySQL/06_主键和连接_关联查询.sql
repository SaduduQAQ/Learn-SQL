# 主键和连接及如何做关联查询

# 模板
#   [CONSTRAINT <外键约束名称>] FOREIGN KEY 字段名
#   REFERENCES <主表名> 字段名

# 添加外键
#   可以在create的时候添加外键，也可以在alter的时候添加外键
#   create
#       create table 从表名
#       (
#           字段名 类型,
#           ...
#           -- 定义外键约束， 指出外键字段和参照的主表字段
#           constraint 外键约束名
#           foreign key 字段名 references 主表名(主键字段名)
#       )

#   alter
#       alter table 从表名 add constraint 约束名 foreign key 字段名 references 主表名(主键字段名)
create table demo.import_head
(
    list_number     int primary key,
    supplier_id     int,
    stock_number    int,
    import_type     int,
    import_quantity decimal(10, 3),
    import_value    decimal(10, 2),
    recorder        int,
    recording_date  datetime
);

create table demo.import_details
(
    list_number  int,
    item_number  int,
    quantity     decimal(10, 3),
    import_price decimal(10, 2),
    import_value decimal(10, 2),
    -- 定义外键约束， 指出外键字段和参照的主表字段
    constraint fk_importDetails_importHead
        foreign key (list_number) references import_head (list_number)
);

select *
from demo.import_head;
select *
from demo.import_details;


select constraint_name,       -- 表示外键约束名称
       table_name,            -- 表示外键约束所属数据表的名称
       column_name,           -- 表示外键约束的字段名称
       referenced_table_name, -- 表示外键约束所参照的数据表名称
       referenced_column_name -- 表示外键约束所参照的字段名称
from information_schema.KEY_COLUMN_USAGE
where constraint_name = 'fk_importDetails_importHead';



select *
from demo.trans;
select *
from demo.member_master;
select a.transaction_no, a.item_number, a.quantity, a.price, a.trans_date, b.member_name
from demo.trans as a
         join
     demo.member_master as b on (a.card_no = b.card_no);

# 左连接
select *
from demo.trans;
select *
from demo.member_master;
select a.transaction_no, a.item_number, a.quantity, a.price, a.trans_date, b.member_name
from demo.trans as a
         left join
     demo.member_master as b
     on (a.card_no = b.card_no);

# 右连接
select *
from demo.trans;
select *
from demo.member_master;
select a.transaction_no, a.item_number, a.quantity, a.price, a.trans_date, b.member_name
from demo.trans as a
         right join
     demo.member_master as b
     on (a.card_no = b.card_no);


# SQL 语句汇总
-- 定义外键约束：
# create table 从表名
# (
#     字段 字段类型
#         .... CONSTRAINT 外键约束名称
#         foreign key (字段名) references 主表名 (字段名称)
# );
# alter table 从表名
#     add constraint 约束名 foreign key 字段名 references 主表名 （字段名）;
#
# -- 连接查询
# select 字段名
# from 表名 as a
#          join 表名 as b
#               on (a.字段名称 = b.字段名称);
#
# select 字段名
# from 表名 as a
#          left join 表名 as b
#                    on (a.字段名称 = b.字段名称);
#
# select 字段名
# from 表名 as a
#          right join 表名 as b
#                     on (a.字段名称 = b.字段名称);