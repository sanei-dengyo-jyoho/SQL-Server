with

v1 as
(
select
	seq as 年度
from
	digits_Q_9999 as a1
where
	( seq between 2001 and (year(GETDATE()) + 1) )
)
,

v2 as
(
select
    システム名
from
    工事種別_T as a2
group by
    システム名
)
,

v3 as
(
select
    b3.システム名
,   a3.年度
from
    v1 as a3
cross join
    v2 as b3
)
,

v4 as
(
select
    a4.システム名
,   a4.年度
from
    v3 as a4
where
    ( a4.年度 <=
        (
        select
            isnull(max(b4.年度),(year(GETDATE()) + 1))
        from
            売上目標_T as b4
        where
            ( b4.システム名 = a4.システム名 )
        )
    )
)
,

v6 as
(
select
    a6.システム名
,   a6.年度
,   b6.顧客金額 + b6.一般金額 as 金額
,   b6.顧客金額
,   b6.一般金額
,   b6.備考
from
    v4 as a6
left outer join
    売上目標_T as b6
    on b6.システム名 = a6.システム名
    and b6.年度 = a6.年度
)

select
    *
from
    v6 as v000
