with

v0 as
(
select
    *
from
    工事台帳_Qリスト as v100
union all
select
    *
from
    工事台帳_Q追加工事リスト as v200
)

select
    *
from
    v0 as v000
