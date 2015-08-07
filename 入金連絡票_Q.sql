with

e0 as
(
select
    eb0.年度
,   ea0.会社コード
,   ea0.会社名
from
    会社_T as ea0
inner join
    会社住所_T年度 as eb0
    on eb0.会社コード = ea0.会社コード
where
    ( ea0.会社コード = '10' )
    and ( eb0.場所名 = N'本社' )
)
,

q0 as
(
select
    工事年度
,   工事種別
,   工事項番
,   max(請求回数) as 請求回数
from
    請求_T as qa0
group by
    工事年度
,   工事種別
,   工事項番
)
,

v0 as
(
select
    t0.システム名
,   format(a0.工事年度,'D4') + a0.工事種別 + '-' + format(a0.工事項番,'D3') as 工事番号
,   a0.工事年度
,   a0.工事種別
,   a0.工事項番
,   t0.工事種別名
,   t0.工事種別コード
,   a0.請求回数
,   N'第' + convert(nvarchar(2),a0.請求回数) + N'回' as 回数
,   y0.会社コード
,   y0.会社名
,   a0.請求先名
,   a0.請求日付
,   a0.発行日付
,   c0.取引先コード
,   d0.取引先名
,   c0.工事件名
,   c0.受注金額
,   c0.消費税額
,   a0.請求本体金額
,   a0.請求消費税率
,   a0.請求消費税額
,   a0.予定現金入金額
,   a0.予定手形入金額
,   a0.予定手形サイト
,   b0.確定日付
,   b0.回収日付
,   b0.振込日付
,   isnull(b0.振込金額,isnull(a0.予定現金入金額,0)) as 振込金額
,   b0.振込手数料
,   isnull(b0.手形金額,isnull(a0.予定手形入金額,0)) as 手形金額
,   b0.手形サイト
,   isnull(b0.手形サイト,a0.予定手形サイト) as サイト
,   b0.手形振出日
,   b0.手形期日
,   b0.手形決済日
,   b0.相殺金額
,   c0.担当会社コード
,   c0.担当部門コード
,   s0.部門名 AS 担当部門名
,   s0.部門名略称 AS 担当部門名略称
,   c0.担当社員コード
,   p0.氏名 AS 担当者名
from
    q0 as x0
left outer join
    請求_T as a0
    on a0.工事年度 = x0.工事年度
    and a0.工事種別 = x0.工事種別
    and a0.工事項番 = x0.工事項番
    and a0.請求回数 = x0.請求回数
left outer join
    入金_T as b0
    on b0.工事年度 = a0.工事年度
    and b0.工事種別 = a0.工事種別
    and b0.工事項番 = a0.工事項番
    and b0.請求回数 = a0.請求回数
left outer join
    工事台帳_T as c0
    on c0.工事年度 = a0.工事年度
    and c0.工事種別 = a0.工事種別
    and c0.工事項番 = a0.工事項番
left outer join
    発注先_Q AS d0
    on d0.工事種別 = a0.工事種別
    and d0.取引先コード = a0.取引先コード
left outer join
    工事種別_T AS t0
    on t0.工事種別 = a0.工事種別
left outer join
    e0 as y0
    on y0.年度 = a0.工事年度
left outer join
    部門_T年度 as s0
    on s0.年度 = y0.年度
    and s0.会社コード = c0.担当会社コード
    and s0.部門コード = c0.担当部門コード
left outer join
    社員_T年度 as p0
    on p0.年度 = y0.年度
    and p0.会社コード = c0.担当会社コード
    and p0.社員コード = c0.担当社員コード
)

SELECT
    *
FROM
    v0 as v000
