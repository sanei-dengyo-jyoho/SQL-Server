with

v0 as
(
select
    t0.システム名
,	dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	t0.工事種別名
,	t0.工事種別コード
,	a0.請求回数
,	dbo.FuncMakeDemandSeq(a0.請求回数) as 回数
,	a0.請求区分
,	a0.請求先名
,	a0.請求日付
,	a0.発行日付
,	a0.請求本体金額
,	a0.請求消費税率
,	a0.請求消費税額
,	a0.予定現金入金額
,	a0.予定手形入金額
,	a0.予定手形サイト
,	b0.確定日付
,	b0.回収日付
,	b0.振込日付
,
   case
        when isnull(a0.振替先部門コード,0) = 0
        then
            case
                when b0.振込金額 is null
                then isnull(a0.予定現金入金額,0)
                else isnull(b0.振込金額,0)+isnull(b0.振込手数料,0)
            end
        else isnull(a0.予定現金入金額,0)
    end
    as 振込金額
,	b0.振込手数料
,
   case
        when isnull(a0.振替先部門コード,0) = 0
        then isnull(b0.手形金額,isnull(a0.予定手形入金額,0))
        else isnull(a0.予定手形入金額,0)
    end
    as 手形金額
,	b0.入金手形サイト
,
   case
        when isnull(a0.振替先部門コード,0) = 0
        then isnull(b0.入金手形サイト,a0.予定手形サイト)
        else a0.予定手形サイト
    end
    as サイト
,	b0.手形振出日
,	b0.手形期日
,	b0.手形決済日
,	b0.相殺金額
,	a0.振替先会社コード
,	a0.振替先部門コード
,	s0.部門名 as 振替先部門名
,	s0.部門名略称 as 振替先部門名略称
,
   dbo.FuncMakeConstructNote(
       a0.振替先部門コード,
       s0.部門名略称,
       a0.請求区分,
       a0.備考)
    as 備考
from
    請求_T as a0
left outer join
    入金_T as b0
    on b0.工事年度 = a0.工事年度
    and b0.工事種別 = a0.工事種別
    and b0.工事項番 = a0.工事項番
    and b0.請求回数 = a0.請求回数
left outer join
    工事種別_T AS t0
    on t0.工事種別 = a0.工事種別
left outer join
    部門_T年度 as s0
    on s0.年度 = a0.工事年度
    and s0.会社コード = a0.振替先会社コード
    and s0.部門コード = a0.振替先部門コード
)

SELECT
    *
FROM
    v0 as v000
