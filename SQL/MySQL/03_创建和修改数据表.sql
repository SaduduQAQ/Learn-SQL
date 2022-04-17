# 怎么创建和修改数据表？
create table demo.import_head
(
    list_number    INT,
    supplier_id    INT,
    stock_number   INT,-- 我们在字段import type定义为INT类型的后面， 按照MySQL创建表的语法， 加了默认值1
    import_type    INT default 1,
    quantity       DECIMAL(10, 3),
    import_value   DECIMAL(10, 2),
    recorder       INT,
    recording_date DATETIME
);

insert into demo.import_head (list_number,
                              supplier_id,
                              stock_number,-- 这里我们没有插入字段import_type的值
                              quantity,
                              import_value,
                              recorder,
                              recording_date)
values (3456,
        1,
        1,
        10,
        100,
        1,
        '2021-12-27');


# show databases;
# use demo;
# show tables;
# desc demo.import_head;
# select * from demo.import_head;

create table demo.import_head_hist like demo.import_head;
alter table demo.import_head_hist add confirmed_person INT;
alter table demo.import_head_hist add confirmed_date DATETIME;
desc demo.import_head_hist;

# 修改字段名 和 字段类型
# alter table demo.import_head_hist change quantity import_quantity double;

# 只修改字段类型
alter table demo.import_head_hist modify import_quantity decimal(10,3);

# 在xx字段后面添加一个字段
alter table demo.import_head_hist add supplier_name text after supplier_id;

/*
常用SQL语句
CREATE TABLE
(
字段名 字段类型 PRIMARY KEY
);
CREATE TABLE
(
字段名 字段类型 NOT NULL
);
CREATE TABLE
(
字段名 字段类型 UNIQUE
);
CREATE TABLE
(
字段名 字段类型 DEFAULT 值
);
-- 这里要注意自增类型的条件，字段类型必须是整数类型。
CREATE TABLE
(
字段名 字段类型 AUTO_INCREMENT
);
-- 在一个已经存在的表基础上，创建一个新表
CREATE TABLE demo.import_head_hist LIKE demo.import_head;
-- 修改表的相关语句
ALTER TABLE 表名 CHANGE 旧字段名 新字段名 数据类型;
ALTER TABLE 表名 ADD COLUMN 字段名 字段类型 FIRST|AFTER 字段名;
ALTER TABLE 表名 MODIFY 字段名 字段类型 FIRST|AFTER 字段名;
 */