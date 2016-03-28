with

v0 as
(
select
	発注条件
,	abs(発注条件 -1) as 発注条件順
,	発注条件名
from
    発注条件_T as a0
)

select
    *
from
    v0 as v000
