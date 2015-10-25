with

v0 as
(
select
    t0.システム名
,   a0.工事種別
,   a0.取引先コード
,   a0.振込日付
,   a0.振込回数
,   min(a0.振込金額) as 振込金額
,   min(a0.振込手数料) as 振込手数料
,   min(a0.振込金額) + min(a0.振込手数料) as 現金入金額
,   sum(b0.振込金額) as 回収金額
,   sum(b0.振込手数料) as 回収手数料
,   sum(b0.振込金額) + sum(b0.振込手数料) as 現金回収額
,   0 as 振替先部門コード
,   1 as 入金条件グループ
,   1 as 入金条件
,   1 as 入金条件索引
,   min(a0.確定日付) as 確定日付
from
    現金入金_T as a0
left outer join
    現金入金_T回収 as b0
    on b0.工事種別 = a0.工事種別
    and b0.取引先コード = a0.取引先コード
    and b0.振込日付 = a0.振込日付
    and b0.振込回数 = a0.振込回数
left outer join
    工事種別_T as t0
    on t0.工事種別 = a0.工事種別
group by
    t0.システム名
,   a0.工事種別
,   a0.取引先コード
,   a0.振込日付
,   a0.振込回数
)
,

v1 as
(
select
    a1.システム名
,   a1.工事種別
,   a1.取引先コード
,   a1.振込日付
,   a1.振込回数
,   a1.振込金額
,   a1.振込手数料
,   a1.現金入金額
,   a1.回収金額
,   a1.回収手数料
,   a1.現金回収額
,   a1.振替先部門コード
,   a1.入金条件グループ
,   a1.入金条件
,   a1.入金条件索引
,   b1.入金条件名
,   a1.確定日付
from
    v0 as a1
left outer join
    入金条件_T as b1
    on b1.入金条件 = a1.入金条件索引
)

select
    *
from
    v1 as v100
