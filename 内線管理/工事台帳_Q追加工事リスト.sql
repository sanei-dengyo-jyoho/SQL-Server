with

r0 as
(
select
    da0.工事年度
,   da0.工事種別
,   da0.工事項番
,   da0.請求回数
,   da0.工事番号枝番
,   da0.請求本体金額
,   da0.請求消費税率
,   da0.請求消費税額
,   da0.請求日付
,   db0.回収日付
,   db0.確定日付
from
    請求_T as da0
left outer join
    入金_T as db0
    on db0.工事年度 = da0.工事年度
    and db0.工事種別 = da0.工事種別
    and db0.工事項番 = da0.工事項番
    and db0.請求回数 = da0.請求回数
where
    (isnull(da0.請求区分,0) > 1)
)
,

v1 as
(
select
    a1.システム名
,   a1.工事番号 + '-' + convert(nvarchar(3),r1.工事番号枝番) as 工事番号
,   a1.工事年度
,   a1.工事種別
,   a1.工事項番
,   a1.工事種別名
,   a1.工事種別コード
,   a1.取引先コード
,   a1.取引先名
,   a1.取引先名カナ
,   a1.取引先略称
,   a1.取引先略称カナ
,   a1.工事件名
,   a1.工事概要
,   a1.県コード
,   a1.市町村コード
,   a1.地区コード
,   a1.県名
,   a1.市区町村名
,   a1.工事場所
,   a1.工期自日付
,   a1.工期至日付
,   a1.工期
,   r1.請求日付 as 受注日付
,   a1.着工日付
,   a1.竣工日付
,   a1.停止日付
,   a1.処理結果
,   a1.処理結果コード
,   a1.処理結果表示
,   r1.請求本体金額 as 受注金額
,   r1.請求消費税率 as 消費税率
,   r1.請求消費税額 as 消費税額
,   case
        when isnull(a1.停止日付,'') <> ''
        then r1.請求本体金額 * -1
        else r1.請求本体金額
    end
    as 受注金額表示
,   case
        when isnull(a1.停止日付,'') <> ''
        then r1.請求消費税額 * -1
        else r1.請求消費税額
    end
    as 消費税額表示
,   a1.担当会社コード
,   a1.担当部門コード
,   a1.担当部門名
,   a1.担当部門名略称
,   a1.集計部門コード
,   a1.集計部門名
,   a1.集計部門名略称
,   a1.担当社員コード
,   a1.担当者名
,   dbo.FuncMakeDemandDateSeq(r1.請求日付,0) as 請求日回数
,   r1.請求回数
,   r1.請求日付
,   r1.回収日付
,   r1.確定日付
,   dbo.FuncMakeReceiptStatus(r1.確定日付,r1.回収日付) as 入金状況
from
    r0 as r1
inner join
    工事台帳_Q as a1
    on a1.工事年度 = r1.工事年度
    and a1.工事種別 = r1.工事種別
    and a1.工事項番 = r1.工事項番
)

select
    *
from
    v1 as v100
