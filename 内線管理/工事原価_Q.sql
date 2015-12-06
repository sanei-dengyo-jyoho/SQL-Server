with

zy0 AS
(
SELECT
	工事年度
,	工事種別
,	工事項番
,	SUM(契約金額) AS 契約金額
FROM
	工事原価_T予算 AS zya0
GROUP BY
	工事年度
,	工事種別
,	工事項番
)
,

zz0 AS
(
SELECT
	工事年度
,	工事種別
,	工事項番
,	SUM(契約金額) AS 契約金額
FROM
	工事原価_T決算 AS zza0
GROUP BY
	工事年度
,	工事種別
,	工事項番
)
,

d0 as
(
select
    da0.工事年度
,   da0.工事種別
,   da0.工事項番
,   max(da0.請求回数) as 請求回数
,   max(db0.回収日付) as 回収日付
,   max(db0.確定日付) as 確定日付
from
    請求_T as da0
left outer join
    入金_T as db0
    on db0.工事年度 = da0.工事年度
    and db0.工事種別 = da0.工事種別
    and db0.工事項番 = da0.工事項番
    and db0.請求回数 = da0.請求回数
where
    (isnull(da0.請求区分,0) <= 1)
group by
    da0.工事年度
,   da0.工事種別
,   da0.工事項番
)
,

r0 as
(
select
    ra0.工事年度
,   ra0.工事種別
,   ra0.工事項番
,   ra0.請求回数
,   ra0.請求日付
,   rb0.回収日付
,   rb0.確定日付
from
    請求_T as ra0
inner join
    d0 as rb0
    on rb0.工事年度 = ra0.工事年度
    and rb0.工事種別 = ra0.工事種別
    and rb0.工事項番 = ra0.工事項番
    and rb0.請求回数 = ra0.請求回数
)
,

v0 as
(
SELECT
    b0.システム名
,   dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,   b0.工事種別名
,   b0.工事種別コード
,	a0.取引先コード
,   c0.取引先名
,   c0.取引先名カナ
,   c0.取引先略称
,   c0.取引先略称カナ
,   a0.取引先担当
,   a0.工事件名
,   a0.工事概要
,   a0.工事場所
,   a0.工期自日付
,   a0.工期至日付
,   dbo.FuncMakeConstructPeriod(a0.工期自日付,a0.工期至日付,DEFAULT) AS 工期
,   a0.受注日付
,   a0.着工日付
,   a0.竣工日付
,   a0.停止日付
,   dbo.FuncMakeConstructStatus(a0.受注日付,a0.着工日付,a0.竣工日付,a0.停止日付) AS 処理結果
,   a0.受注金額
,   a0.消費税率
,   a0.消費税額
,   j0.[JV]
,   isnull(j0.請負受注金額,a0.受注金額) AS 請負受注金額
,   isnull(j0.請負消費税率,a0.消費税率) AS 請負消費税率
,   isnull(j0.請負消費税額,a0.消費税額) AS 請負消費税額
,	x0.予算日付
,   y0.契約金額 AS 予算原価
,   format(y0.契約金額,'c') AS 予算原価額
,	dbo.FuncMakePercentFormat(y0.契約金額,isnull(j0.請負受注金額,a0.受注金額)) AS 予算原価率
,	x0.決算日付
,   z0.契約金額 AS 決算原価
,   format(z0.契約金額,'c') AS 決算原価額
,	dbo.FuncMakePercentFormat(z0.契約金額,isnull(j0.請負受注金額,a0.受注金額)) AS 決算原価率
,   ISNULL(x0.担当会社コード,a0.担当会社コード) AS 担当会社コード
,   ISNULL(x0.担当部門コード,a0.担当部門コード) AS 担当部門コード
,   ISNULL(x0.担当社員コード,a0.担当社員コード) AS 担当社員コード
,   dbo.FuncMakeDemandDateSeq(g0.請求日付,isnull(g0.請求回数,0)) AS 請求日回数
,   g0.請求回数
,   g0.請求日付
,   g0.回収日付
,   g0.確定日付
,   dbo.FuncMakeReceiptStatus(g0.確定日付,g0.回収日付) AS 入金状況
FROM
    工事台帳_T AS a0
LEFT OUTER JOIN
    工事種別_T AS b0
    ON b0.工事種別 = a0.工事種別
LEFT OUTER JOIN
    工事台帳_Q共同企業体出資比率 AS j0
    ON j0.工事年度 = a0.工事年度
    AND j0.工事種別 = a0.工事種別
    AND j0.工事項番 = a0.工事項番
LEFT OUTER JOIN
	工事原価_T AS x0
    ON x0.工事年度 = a0.工事年度
    AND x0.工事種別 = a0.工事種別
    AND x0.工事項番 = a0.工事項番
LEFT OUTER JOIN
    zy0 AS y0
    ON y0.工事年度 = x0.工事年度
    AND y0.工事種別 = x0.工事種別
    AND y0.工事項番 = x0.工事項番
LEFT OUTER JOIN
    zz0 AS z0
    ON z0.工事年度 = x0.工事年度
    AND z0.工事種別 = x0.工事種別
    AND z0.工事項番 = x0.工事項番
LEFT OUTER JOIN
    発注先_Q AS c0
    ON c0.工事種別 = a0.工事種別
    AND c0.取引先コード = a0.取引先コード
LEFT OUTER JOIN
    r0 AS g0
    ON g0.工事年度 = a0.工事年度
    AND g0.工事種別 = a0.工事種別
    AND g0.工事項番 = a0.工事項番
)
,

v1 as
(
SELECT
    a1.システム名
,   a1.工事番号
,	a1.工事年度
,	a1.工事種別
,	a1.工事項番
,   a1.工事種別名
,   a1.工事種別コード
,	a1.取引先コード
,   a1.取引先名
,   a1.取引先名カナ
,   a1.取引先略称 AS 発注者
,   a1.取引先略称
,   a1.取引先略称カナ
,   a1.取引先担当
,   a1.工事件名
,   a1.工事概要
,   a1.工事場所
,   a1.工期自日付
,   a1.工期至日付
,   a1.工期
,   isnull(d1.和暦日付,N'') + N' ～ ' + isnull(d2.和暦日付,N'') AS 工事期間
,   a1.受注日付
,   a1.着工日付
,   a1.竣工日付
,   a1.停止日付
,   a1.処理結果
,   b1.工事処理結果コード as 処理結果コード
,   b1.工事処理結果表示 as 処理結果表示
,   dbo.FuncMakeMoneyFormat(ISNULL(a1.請負受注金額,0)) + SPACE(3) + N'（税別）' AS 税別請負受注額
,   a1.受注金額
,   a1.消費税率
,   a1.消費税額
,   a1.[JV]
,   a1.請負受注金額
,   a1.請負消費税率
,   a1.請負消費税額
,   a1.請負受注金額 + a1.請負消費税額 AS 請負総額
,	a1.予算日付
,   a1.予算原価
,   a1.予算原価額
,	a1.予算原価率
,	a1.決算日付
,   a1.決算原価
,   a1.決算原価額
,	a1.決算原価率
,   a1.担当会社コード
,   a1.担当部門コード
,   s1.部門名 AS 担当部門名
,   s1.部門名略称 AS 担当部門名略称
,   s1.集計部門コード
,   s2.部門名 AS 集計部門名
,   s2.部門名略称 AS 集計部門名略称
,   a1.担当社員コード
,   e1.氏名 AS 担当者名
,   a1.請求日回数
,   a1.請求回数
,   a1.請求日付
,   a1.回収日付
,   a1.確定日付
,   a1.入金状況
,	d3.和暦日付 AS 和暦作成日
,	1 AS 頁1
,	2 AS 頁2
,	3 AS 頁3
,	4 AS 頁4
,	5 AS 頁5
,	6 AS 頁6
FROM
	v0 AS a1
LEFT OUTER JOIN
    工事処理結果_T as b1
    on b1.工事処理結果 = a1.処理結果
LEFT OUTER JOIN
    カレンダ_Q AS d1
    ON d1.日付 = a1.工期自日付
LEFT OUTER JOIN
    カレンダ_Q AS d2
    ON d2.日付 = a1.工期至日付
LEFT OUTER JOIN
    カレンダ_Q AS d3
    ON d3.日付 = format(GETDATE(),'d')
LEFT OUTER JOIN
    部門_T年度 AS s1
    ON s1.年度 = a1.工事年度
    AND s1.会社コード = a1.担当会社コード
    AND s1.部門コード = a1.担当部門コード
LEFT OUTER JOIN
    部門_T年度 AS s2
    ON s2.年度 = s1.年度
    AND s2.会社コード = s1.会社コード
    AND s2.部門コード = s1.集計部門コード
LEFT OUTER JOIN
    社員_T年度 AS e1
    ON e1.年度 = a1.工事年度
    AND e1.会社コード = a1.担当会社コード
    AND e1.社員コード = a1.担当社員コード
)

select
	*
from
	v1 as v100
