use demo;
show tables;

# 使用业务字段做主键
create table demo.member_master
(
    card_no        char(8) primary key,
    member_name    text,
    member_phone   text,
    member_pid     text,
    member_address text,
    sex            text,
    birthday       datetime
);
desc demo.member_master;

insert into demo.member_master
(card_no,
 member_name,
 member_phone,
 member_pid,
 member_address,
 sex,
 birthday)
values ('10000001',
        '张三',
        '13812345678',
        '110123200001017890',
        '北京',
        '男',
        '2000-01-01');

insert into demo.member_master
(card_no,
 member_name,
 member_phone,
 member_pid,
 member_address,
 sex,
 birthday)
values ('10000002',
        '李四',
        '13512345678',
        '123123199001012356',
        '上海',
        '女',
        '1990-01-01');

select *
from demo.member_master;

# 但是这样插入是有问题的，实际情况是，上线不到一周，就发生了“card_no”无法唯一识别某一个会员的问题。
# 原来，会员卡号存在重复使用的情况。
# 这也很好理解，比如，张三因为工作变动搬离了原来的地址，不再到商家的门店消费了（退还了会员卡），
# 于是张三就不再是这个商家门店的会员了。但是，商家不想让这个会员卡空着，就把卡号是“10000001”的会员卡发给了王五。


create table demo.trans
(
    transaction_no INT,
    item_number    INT,     -- 为了引用商品信息
    quantity       DECIMAL(10, 3),
    price          DECIMAL(10, 2),
    sales_value    DECIMAL(10, 2),
    card_no        CHAR(8), -- 为了引用会员信息
    trans_date     DATETIME
);

insert into demo.trans
(transaction_no,
 item_number,
 quantity,
 price,
 sales_value,
 card_no,
 trans_date)
values (1,
        1,
        1,
        89,
        89,
        '10000001',
        '2020-12-01');


select b.member_name, c.goods_name, a.quantity, a.sales_value, a.trans_date
from demo.trans as a
         join demo.member_master as b
         join demo.goods_master as c
              on (a.card_no = b.card_no and a.item_number = c.item_number);
# 尽量不要用业务字段，也就是跟业务有关的字段做主键(身份证)
# 1. 身份证人家不一定愿意给
# 2. 电话有可能会被回收
# 3. 会员卡号也会被回收


### 使用自增字段做主键
# 第一步，修改会员信息表，删除表的主键约束，
# 这样，原来的主键字段，就不再是主键了。不过需要注意的是，删除主键约束，并不会删除字段。
alter table demo.member_master
    drop primary key;
alter table demo.member_master
    add id int primary key auto_increment;
alter table demo.trans
    add member_id int;

update demo.trans as a,demo.member_master as b
set a.member_id=b.id
where a.transaction_no > 0
  and a.card_no = b.card_no; -- 这样操作可以不用删除trans的内容，在实际工作中更适合

select *
from demo.trans;

insert into demo.member_master
(card_no,
 member_name,
 member_phone,
 member_pid,
 member_address,
 sex,
 birthday)
values ('10000001',
        '王五',
        '13698765432',
        '475145197001012356',
        '天津',
        '女',
        '1970-01-01');

select *
from demo.member_master;


select b.member_name, c.goods_name, a.quantity, a.sales_value, a.trans_date
from demo.trans as a
         join demo.member_master as b
         join demo.goods_master as c
              on (a.member_id = b.id and a.item_number = c.item_number);
# 如果是一个小项目，只有一个 MySQL 数据库服务器，用添加自增字段作为主键的办法是可以的。
# 不过，这并不意味着，在任何情况下你都可以这么做。

### 手动赋值字段做主键
# 取消字段“id”的自增属性，改成信息系统在添加会员的时候对“id”进行赋值。
# 在总部 MySQL 数据库中，有一个管理信息表，里面的信息包括成本核算策略，支付方式等，
# 还有总部的系统参数，我们可以在这个表中添加一个字段，专门用来记录当前会员编号的最大值。
# 门店在添加会员的时候，先到总部 MySQL 数据库中获取这个最大值，在这个基础上加 1，然后用这个值作为新会员的“id”，
# 同时，更新总部 MySQL 数据库管理信息表中的当前会员编号的最大值。

desc demo.goods_master;
desc demo.trans;
desc demo.member_master;
select *
from demo.goods_master;
select *
from demo.trans;
select *
from demo.member_master;

# 思考题：如果我想把销售流水表 demo.trans 中，所有单位是“包”的商品的价格改成原来价格的 80%，该怎么实现呢？
# update demo.trans as a,
#     demo.goods_master as b
# set price = price * 0.8
# where a.item_number = b.item_number
#   and b.unit = '包'