with

v1 as
(
select
    a1.年度
,   b1.部所グループコード
from
    (
    select
        a0.年度
    from
        部所グループ_T年度 as a0
    group by
        a0.年度
    )
    as a1
cross join
    (
    select
        b0.部所グループコード
    from
        部所グループ_T年度 as b0
    group by
        b0.部所グループコード
    )
    as b1
group by
    a1.年度
,   b1.部所グループコード
)

select
    *
from
    v1 as v100
