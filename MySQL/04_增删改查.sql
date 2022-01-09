describe demo.goods_master;
select *
from demo.goods_master;

# 添加数据
# INSERT INTO 表名 [(字段名 [,字段名] ...)] VALUES (值的列表);
# 插入数据记录
use demo;
alter table demo.goods_master
    add column specification varchar(255) after goods_name;
alter table demo.goods_master
    add column unit varchar(255) after specification;

insert into demo.goods_master
(item_number,
 barcode,
 goods_name,
 specification,
 unit,
 price)
values (5, '0003', '尺子', '三角形', '把', 5);


insert into demo.goods_master
(
-- 其他的先不赋值
-- 这里只给3个字段赋值，item_number、specification、unit不赋值
    barcode,
    goods_name,
    price)
values ('0004',
        '测试',
        10);

# 插入查询结果
# insert into 表名 （字段名）
# select 字段名或值
# from 表名
# where 条件

# 删除数据
# delete
# from 表名
# where 条件
# delete
# from demo.goods_master;  # 删除所有数据

# 修改数据
# update 表名
# set 字段名=值
# where 条件
# !!!! 不要修改主键的值

# 查询数据

# select * | 字段列表
# from 数据源
# where 条件
# group by 字段
# having 条件
# order by 字段
# limit 起始点，行数