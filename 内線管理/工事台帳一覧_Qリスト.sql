with

v0 as
(
select
    a0.*
from
    工事台帳_Qリスト as a0

union all

select
    b0.*
from
    工事台帳_Q追加工事リスト as b0
)

select
    *
from
    v0 as v000
