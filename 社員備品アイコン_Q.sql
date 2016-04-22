with

v0 as
(
select
    t0.名称
,   '00' + convert(varchar(8),t0.名称番号) AS 名称番号
from
    名称_T as t0
where
    ( t0.名称コード = 130 )
    and ( ( t0.名称 = N'男性' ) or ( t0.名称 = N'女性' ) )

union all

select
    t1.名称
,   '10' + convert(varchar(8),t1.名称番号) AS 名称番号
from
    名称_T as t1
where
    ( t1.名称コード = 138 )
)

select
    *
from
    v0 as v000
