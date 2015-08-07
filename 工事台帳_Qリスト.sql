with

d0 as
(
select
    da0.工事年度
,   da0.工事種別
,   da0.工事項番
,   max(da0.請求回数) as 請求回数
,   max(db0.回収日付) as 回収日付
,   max(db0.確定日付) as 確定日付
from
    請求_T as da0
left outer join
    入金_T as db0
    on db0.工事年度 = da0.工事年度
    and db0.工事種別 = da0.工事種別
    and db0.工事項番 = da0.工事項番
    and db0.請求回数 = da0.請求回数
group by
    da0.工事年度
,   da0.工事種別
,   da0.工事項番
)
,

r0 as
(
select
    ra0.工事年度
,   ra0.工事種別
,   ra0.工事項番
,   ra0.請求回数
,   ra0.請求日付
,   rb0.回収日付
,   rb0.確定日付
from
    請求_T as ra0
inner join
    d0 as rb0
    on rb0.工事年度 = ra0.工事年度
    and rb0.工事種別 = ra0.工事種別
    and rb0.工事項番 = ra0.工事項番
    and rb0.請求回数 = ra0.請求回数
)
,

v1 as
(
select
    a1.*
,   case
        when isnull(r1.請求日付,'') = ''
        then N''
        else convert(varchar(10),r1.請求日付,111) +
            case when isnull(r1.請求回数,1) = 1
                then N''
                else N' 第' + convert(nvarchar(3),r1.請求回数) + N'回'
            end
    end
    as 請求日回数
,   r1.請求回数
,   r1.請求日付
,   r1.回収日付
,   r1.確定日付
from
    工事台帳_Q as a1
left outer join
    r0 as r1
    on r1.工事年度 = a1.工事年度
    and r1.工事種別 = a1.工事種別
    and r1.工事項番 = a1.工事項番
)

select
    *
from
    v1 as v100
