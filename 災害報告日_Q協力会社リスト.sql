with

v0 as
(
select
    a0.協力会社コード
,   a0.部門コード
,   s0.部門名
,   c0.年度
,   a0.日付
,   a0.災害コード
,   r0.災害警告コード
,
    case
        when isnull(q0.事故種別,N'') = N''
        then N''
        else N'（' + q0.事故種別 + N'）' + space(1)
    end
    + r0.災害名
    as 災害名
from
    (
    select
        a00.協力会社コード
    ,   a00.部門コード
    ,   a00.日付
    ,   a00.災害コード
    ,
        case
            when a00.災害コード <> 1
            then 1
        end
        as 事故種別コード
    from
        災害事故報告日_Q協力会社 as a00

    union all

    select
        a01.協力会社コード
    ,   a01.部門コード
    ,   a01.日付
    ,   a01.災害コード
    ,
        case
            when a01.災害コード <> 1
            then 2
        end
        as 事故種別コード
    from
        車両事故報告日_Q協力会社 as a01
    )
    as a0
INNER JOIN
    災害コード_Q as r0
	ON r0.災害コード = a0.災害コード
INNER JOIN
    カレンダ_T as c0
	ON c0.日付 = a0.日付
LEFT OUTER JOIN
    事故種別_Q as q0
	ON q0.事故種別コード = a0.事故種別コード
LEFT OUTER JOIN
    部門_T年度 as s0
	ON s0.年度 = c0.年度
	AND s0.部門コード = a0.部門コード
group by
    a0.協力会社コード
,   a0.部門コード
,   s0.部門名
,   c0.年度
,   a0.日付
,   a0.災害コード
,   q0.事故種別
,   r0.災害警告コード
,   r0.災害名
)

select
    *
from
    v0 as v000

