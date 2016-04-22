with

v1 as
(
select
    a1.年度
,   b1.協力会社コード
from
    (
    select
        a0.年度
    from
        協力会社_T年度 as a0
    group by
        a0.年度
    )
    as a1
cross join
    (
    select
        b0.協力会社コード
    from
        協力会社_T年度 as b0
    group by
        b0.協力会社コード
    )
    as b1
group by
    a1.年度
,   b1.協力会社コード
)

select
    *
from
    v1 as v100
