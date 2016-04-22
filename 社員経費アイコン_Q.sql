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
    t1.経費 AS 名称
,   convert(varchar(8),88000+t1.経費コード) AS 名称番号
from
    経費コード_T as t1

union all

select
    t2.経費理由 AS 名称
,   convert(varchar(8),99000+t2.経費理由コード) AS 名称番号
from
    経費理由コード_T as t2
)

select
    *
from
    v0 as v000
