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

v0 as
(
select
    a0.システム名
,   a0.工事番号
,   a0.工事年度
,   a0.工事種別
,   a0.工事項番
,   a0.工事種別名
,   a0.工事種別コード
,   y0.会社コード
,   y0.会社名
,   a0.取引先コード
,   a0.取引先名
,   a0.工事件名
,   a0.工事場所
,   a0.工期
,   a0.工期自日付
,   a0.工期至日付
,   a0.受注日付
,   a0.着工日付
,   a0.竣工日付
,   a0.受注金額
,   a0.消費税額
,   a0.担当会社コード
,   a0.担当部門コード
,   a0.担当部門名
,   a0.担当部門名略称
,   a0.担当社員コード
,   a0.担当者名
from
    工事台帳_Q as a0
left outer join
    e0 as y0
    on y0.年度 = a0.工事年度
)

SELECT
    *
FROM
    v0 as v000
