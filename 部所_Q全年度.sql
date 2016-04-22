with

v1 as
(
select
    a1.年度
,   b1.部所グループコード
,   b1.部所コード
from
    (
    select
        a0.年度
    from
        部所_T年度 as a0
    group by
        a0.年度
    )
    as a1
cross join
    (
    select
        b0.部所グループコード
    ,   b0.部所コード
    from
        部所_T年度 as b0
    group by
        b0.部所グループコード
    ,   b0.部所コード
    )
    as b1
group by
    a1.年度
,   b1.部所グループコード
,   b1.部所コード
)

select
    *
from
    v1 as v100
