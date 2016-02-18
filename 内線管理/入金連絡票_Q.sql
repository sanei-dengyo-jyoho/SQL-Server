with

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
    c0.システム名
,   c0.工事番号
,   a0.工事年度
,   a0.工事種別
,   a0.工事項番
,   c0.工事種別名
,   c0.工事種別コード
,   a0.請求回数
,   dbo.FuncMakeDemandSeq(a0.請求回数) as 回数
,   y0.会社コード
,   y0.会社名
,   a0.請求先名
,   a0.請求日付
,   a0.発行日付
,   c0.取引先コード
,   c0.取引先名
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
,   b0.振込手数料
,
   case
        when isnull(a0.振替先部門コード,0) = 0
        then isnull(b0.手形金額,isnull(a0.予定手形入金額,0))
        else isnull(a0.予定手形入金額,0)
    end
    as 手形金額
,   b0.入金手形サイト
,
   case
        when isnull(a0.振替先部門コード,0) = 0
        then isnull(b0.入金手形サイト,a0.予定手形サイト)
        else a0.予定手形サイト
    end
    as サイト
,   b0.手形振出日
,   b0.手形期日
,   b0.手形決済日
,   b0.相殺金額
,   a0.振替先会社コード
,   a0.振替先部門コード
,   c0.担当会社コード
,   c0.担当部門コード
,   c0.担当部門名
,   c0.担当部門名略称
,   c0.担当社員コード
,   c0.担当者名
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
    工事台帳_Q as c0
    on c0.工事年度 = a0.工事年度
    and c0.工事種別 = a0.工事種別
    and c0.工事項番 = a0.工事項番
left outer join
    当社_Q as y0
    on y0.年度 = a0.工事年度
)

SELECT
    *
FROM
    v0 as v000
