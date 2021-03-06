with

v1 as
(
select
    a1.システム名
,	a1.工事番号
,	a1.工事年度
,	a1.工事種別
,	a1.工事項番
,	a1.工事種別名
,	a1.工事種別コード
,	a1.発注先種別名
,	a1.取引先コード
,	a1.取引先名
,	a1.取引先名カナ
,	a1.取引先略称
,	a1.取引先略称カナ
,	a1.取引先担当
,	a1.得意先
,	a1.請負コード
,	a1.請負名
,	a1.工事件名
,	a1.工事概要
,	a1.県コード
,	a1.市町村コード
,	a1.地区コード
,	a1.県名
,	a1.市区町村名
,	a1.工事場所
,	a1.工期自日付
,	a1.工期至日付
,	a1.工期
,	a1.受注日付
,	a1.着工日付
,	a1.竣工日付
,	a1.停止日付
,	a1.処理結果
,	a1.処理結果コード
,	a1.処理結果表示
,	a1.受注金額
,	a1.消費税率
,	a1.消費税額
,	a1.受注金額表示
,	a1.消費税額表示
,	a1.共同企業体形成コード
,	a1.[JV]
,	a1.[JV出資比率]
,	a1.請負受注金額
,	a1.請負消費税率
,	a1.請負消費税額
,	a1.請負総額
,	a1.請負受注金額表示
,	a1.請負消費税額表示
,	a1.担当会社コード
,	a1.担当部門コード
,	a1.担当部門名
,	a1.担当部門名略称
,	a1.集計部門コード
,	a1.集計部門名
,	a1.集計部門名略称
,	a1.担当社員コード
,	a1.担当者名
,	dbo.FuncMakeDemandDateSeq(r1.請求日付,isnull(r1.請求回数,0)) as 請求日回数
,	r1.請求回数
,	r1.請求日付
,	r1.回収日付
,	r1.確定日付
,	dbo.FuncMakeReceiptStatus(r1.確定日付,r1.回収日付) as 入金状況
from
    工事台帳_Q as a1
left outer join
    (
    select
        ra0.工事年度
    ,	ra0.工事種別
    ,	ra0.工事項番
    ,	ra0.請求回数
    ,	ra0.請求日付
    ,	rb0.回収日付
    ,	rb0.確定日付
    from
        請求_T as ra0
    inner join
        (
        select
            da0.工事年度
        ,	da0.工事種別
        ,	da0.工事項番
        ,	max(da0.請求回数) as 請求回数
        ,	max(db0.回収日付) as 回収日付
        ,	max(db0.確定日付) as 確定日付
        from
            請求_T as da0
        left outer join
            入金_T as db0
            on db0.工事年度 = da0.工事年度
            and db0.工事種別 = da0.工事種別
            and db0.工事項番 = da0.工事項番
            and db0.請求回数 = da0.請求回数
        where
            ( isnull(da0.請求区分,0) <= 1 )
        group by
            da0.工事年度
        ,	da0.工事種別
        ,	da0.工事項番
        )
        as rb0
        on rb0.工事年度 = ra0.工事年度
        and rb0.工事種別 = ra0.工事種別
        and rb0.工事項番 = ra0.工事項番
        and rb0.請求回数 = ra0.請求回数
    )
    as r1
    on r1.工事年度 = a1.工事年度
    and r1.工事種別 = a1.工事種別
    and r1.工事項番 = a1.工事項番
)

select
    *
from
    v1 as v100
