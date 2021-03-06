with

v0 as
(
SELECT
    b1.システム名
,	dbo.FuncMakeConstructNumber(a1.工事年度,a1.工事種別,a1.工事項番) AS 工事番号
,	a1.工事年度
,	a1.工事種別
,	a1.工事項番
,	ISNULL(d7.和暦日付,N'') AS 和暦発行日
,	y1.会社コード
,	y1.会社名
,	a1.取引先コード
,	c1.取引先名
,	c1.取引先名カナ
,	c1.取引先略称
,	c1.取引先略称カナ
,	a1.取引先担当
,	a1.工事件名
,	a1.工事概要
,	a1.工事場所
,	a1.工期自日付
,	a1.工期至日付
,	dbo.FuncMakeConstructPeriod(d1.和暦日付,d2.和暦日付,DEFAULT) AS 和暦工期
,	a1.受注日付
,	ISNULL(d3.和暦日付,N'') AS 和暦受注日
,	a1.着工日付
,	ISNULL(d4.和暦日付,N'') AS 和暦着工日
,	a1.竣工日付
,	ISNULL(d5.和暦日付,N'') AS 和暦竣工日
,	a1.停止日付
,	a1.受注金額
,	a1.受注金額 AS 本体金額
,	a1.消費税率
,	a1.消費税額
,	ISNULL(a1.受注金額,0) + ISNULL(a1.消費税額,0) AS 合計金額
,	j0.[JV]
,	j0.税別出資比率
,	j0.税別出資比率詳細
,	j0.税別出資比率段落
,	j0.税別出資比率詳細段落
,	j0.税込出資比率
,	j0.税込出資比率詳細
,	j0.税込出資比率段落
,	j0.税込出資比率詳細段落
,	r1.請求回数
,	r1.請求日付
,	r1.回収日付
,	ISNULL(d6.和暦日付,N'') AS 和暦回収日
,	r1.確定日付
,	dbo.FuncMakeReceiptStatus(r1.確定日付,r1.回収日付) as 入金状況
FROM
    (
    SELECT
        ca0.*
    ,	format(GETDATE(),'d') AS 発行日付
    FROM
        工事台帳_T AS ca0
    )
    AS a1
LEFT OUTER JOIN
    工事種別_T AS b1
    ON b1.工事種別 = a1.工事種別
LEFT OUTER JOIN
    工事台帳_Q共同企業体出資比率 AS j0
    ON j0.工事年度 = a1.工事年度
    AND j0.工事種別 = a1.工事種別
    AND j0.工事項番 = a1.工事項番
LEFT OUTER JOIN
    発注先_Q AS c1
    ON c1.工事種別 = a1.工事種別
    AND c1.取引先コード = a1.取引先コード
LEFT OUTER JOIN
    当社_Q内線 AS y1
    ON y1.年度 = a1.工事年度
LEFT OUTER JOIN
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
    AS r1
    ON r1.工事年度 = a1.工事年度
    AND r1.工事種別 = a1.工事種別
    AND r1.工事項番 = a1.工事項番
LEFT OUTER JOIN
    カレンダ_Q AS d1
    ON d1.日付 = a1.工期自日付
LEFT OUTER JOIN
    カレンダ_Q AS d2
    ON d2.日付 = a1.工期至日付
LEFT OUTER JOIN
    カレンダ_Q AS d3
    ON d3.日付 = a1.受注日付
LEFT OUTER JOIN
    カレンダ_Q AS d4
    ON d4.日付 = a1.着工日付
LEFT OUTER JOIN
    カレンダ_Q AS d5
    ON d5.日付 = a1.竣工日付
LEFT OUTER JOIN
    カレンダ_Q AS d6
    ON d6.日付 = r1.回収日付
LEFT OUTER JOIN
    カレンダ_Q AS d7
    ON d7.日付 = a1.発行日付
)

SELECT
    *
FROM
    v0 as v000
