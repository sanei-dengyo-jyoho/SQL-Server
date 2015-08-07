with

v1 as
(
select
    t1.システム名
,   a1.工事種別
,   a1.取引先コード
,   a1.振込日付
,   a1.振込回数
,   min(a1.振込金額) as 振込金額
,   min(a1.振込手数料) as 振込手数料
,   min(a1.振込金額) + min(a1.振込手数料) as 現金入金額
,   sum(b1.振込金額) as 回収金額
,   sum(b1.振込手数料) as 回収手数料
,   sum(b1.振込金額) + sum(b1.振込手数料) as 現金回収額
,   0 as 振替先部門コード
,   100 as 現金割合
,   min(a1.確定日付) as 確定日付
from
    現金入金_T as a1
left outer join
    現金入金_T回収 as b1
    on b1.工事種別 = a1.工事種別
    and b1.取引先コード = a1.取引先コード
    and b1.振込日付 = a1.振込日付
    and b1.振込回数 = a1.振込回数
left outer join
    工事種別_T as t1
    on t1.工事種別 = a1.工事種別
group by
    t1.システム名
,   a1.工事種別
,   a1.取引先コード
,   a1.振込日付
,   a1.振込回数
)

select
    *
from
    v1 as v100
