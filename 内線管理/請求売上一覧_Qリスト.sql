with

v0 as
(
select
    a0.*
from
    入金回収_Qリスト as a0

union all

select
    b0.*
from
    請求売上_Q未請求リスト as b0
)

select
    *
from
    v0 as v000
