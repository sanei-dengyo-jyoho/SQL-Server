with

v0 as
(
select
    *
from
    入金回収_Qリスト as v100
union all
select
    *
from
    請求売上_Q未請求リスト as v200
)

select
    *
from
    v0 as v000
