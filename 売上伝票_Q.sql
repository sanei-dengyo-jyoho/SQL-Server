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
,   取引先コード
,   工事件名
,   工事場所
,   実績工期自
,   実績工期至
,   受注日付
,   着工日付
,   竣工日付
,   受注金額
,   消費税額
,   担当会社コード
,   担当部門コード
,   担当社員コード
from
    工事台帳_T as qa0
where
    ( isnull(竣工日付,'') <> '' )
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
,   y0.会社コード
,   y0.会社名
,   a0.取引先コード
,   d0.取引先名
,   a0.工事件名
,   a0.工事場所
,   case
        when ISNULL(a0.実績工期自,'') <> '' and ISNULL(a0.実績工期至,'') <> ''
        then format(a0.実績工期自,'d') + N' ～ ' + format(a0.実績工期至,'d')
        when ISNULL(a0.実績工期自,'') <> '' and ISNULL(a0.実績工期至,'') = ''
        then format(a0.実績工期自,'d') + N' ～ '
        when ISNULL(a0.実績工期自,'') = '' and ISNULL(a0.実績工期至,'') <> ''
        then N' ～ ' + format(a0.実績工期至,'d')
        else N''
    end
    AS 実績工期
,   a0.実績工期自
,   a0.実績工期至
,   a0.受注日付
,   a0.着工日付
,   a0.竣工日付
,   a0.受注金額
,   a0.消費税額
,   a0.担当会社コード
,   a0.担当部門コード
,   s0.部門名 AS 担当部門名
,   s0.部門名略称 AS 担当部門名略称
,   a0.担当社員コード
,   p0.氏名 AS 担当者名
from
    q0 as a0
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
    and s0.会社コード = a0.担当会社コード
    and s0.部門コード = a0.担当部門コード
left outer join
    社員_T年度 as p0
    on p0.年度 = y0.年度
    and p0.会社コード = a0.担当会社コード
    and p0.社員コード = a0.担当社員コード
)

SELECT
    *
FROM
    v0 as v000
