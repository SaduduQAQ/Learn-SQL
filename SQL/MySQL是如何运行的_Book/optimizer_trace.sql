show variables like 'optimizer_trace';

set optimizer_trace = "enabled=on";

set optimizer_trace = "enabled=off";

select *
from demo.goods_master
where price > 1;

select *
from information_schema.OPTIMIZER_TRACE;