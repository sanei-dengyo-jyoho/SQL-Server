WITH

v2 AS
(
SELECT
	a.年度
,	a.[管理№]
,	CONVERT(varchar(10),a.日付,111) AS 日付
,	u.曜日名 AS 曜日
,	ISNULL(uw.年号,N'') + CONVERT(nvarchar(20),dbo.FuncGetNumberFixed(ISNULL(uw.年,0),DEFAULT)) + N'年' + CONVERT(nvarchar(20),dbo.FuncGetNumberFixed(MONTH(a.日付),DEFAULT)) + N'月' + CONVERT(nvarchar(20),dbo.FuncGetNumberFixed(DAY(a.日付),DEFAULT)) + N'日' + N' (' + ISNULL(u.曜日名,N'') + N') ' AS 日付表示
,	a.年月
,	a.年
,	a.月
,	a.日
,	uw.年号
,	uw.年号略称
,	uw.年 AS 和暦年
,	CONVERT(nvarchar(4),a.年) + N'/' + CONVERT(nvarchar(20),dbo.FuncGetNumberFixed(MONTH(a.月),DEFAULT)) AS 年月度
,	CONVERT(nvarchar(4),a.年) + N'年' + CONVERT(nvarchar(20),dbo.FuncGetNumberFixed(MONTH(a.月),DEFAULT)) + N'月' AS 年月表示
,	CONVERT(varchar(5),a.時刻,108) AS 時刻
,	CONVERT(varchar(5),a.時刻,108) AS 時刻表示
,	t.時間帯コード
,	t.時間帯
,	a.協力会社コード
,	g.協力会社名
,	b.社員コード
,	ISNULL(b.氏名,ISNULL(a.被災者名,N'')) AS 氏名
,	b.カナ氏名
,	ISNULL(a.年齢年,ISNULL(a.被災者年齢年,0)) AS 年齢年
,	ISNULL(a.年齢月,ISNULL(a.被災者年齢月,0)) AS 年齢月
,	CONVERT(nvarchar(4),ISNULL(a.年齢年,ISNULL(a.被災者年齢年,0))) + N'才' + CONVERT(nvarchar(4),ISNULL(a.年齢月,ISNULL(a.被災者年齢月,0))) + N'ヶ月' AS 年齢
,	ISNULL(a.経験年,ISNULL(a.被災者経験年,0)) AS 経験年
,	ISNULL(a.経験月,ISNULL(a.被災者経験月,0)) AS 経験月
,	CONVERT(nvarchar(4),ISNULL(a.経験年,ISNULL(a.被災者経験年,0))) + N'年' + CONVERT(nvarchar(4),ISNULL(a.経験月,ISNULL(a.被災者経験月,0))) + N'ヶ月' AS 経験
,	b.性別
,	b.生年月日
,	b.入社日
,	b.退職日
,	b.退職年度
,	d.職制区分
,	d.職制区分名
,	d.職制区分名略称
,	e.職制コード
,	e.職制名
,	e.職制名略称
,	f.係コード
,	f.係名
,	f.係名略称
,	f.係名省略
,	j.部所グループコード
,	i.部所コード
,	j.部所グループ名
,	i.部所名
,	c.順序コード
,	c.本部コード
,	c.部コード
,	c.所在地コード
,	c.部門レベル
,	c.部門コード
,	c.県コード
,	c.本部名
,	c.部名
,	c.部門名
,	c.場所名
,	c.県名
,	c.部門名カナ
,	c.部門名略称
,	c.部門名省略
,	cs.部門名階層段落 AS 所属
,	a.天候コード
,	dbo.FuncGetOtherString(ISNULL(k.天候名,N'その他'),ISNULL(a.天候その他,N''),DEFAULT) AS 天候
,	ISNULL(p.災害コード,11) AS 災害コード
,	a.休業コード
,	ISNULL(p.休業名,'') AS 休業名
,	a.期間
,	a.期間コード
,	ISNULL(q.期間名,'') AS 期間名
,	a.県コード AS 現場県コード
,	a.市町村コード AS 現場市町村コード
,	a.住所 AS 現場住所
,	a.種別
,	a.障害状況
,	a.作業内容
,	a.備考
,	a.労災認定
,	a.状況詳細
,	a.原因詳細
,	a.対策詳細

FROM
	災害事故報告_T AS a
LEFT OUTER JOIN
	協力会社_T年度 AS g
	ON g.年度 = a.年度
	AND g.協力会社コード = a.協力会社コード
LEFT OUTER JOIN
	社員_T年度 AS b
	ON b.年度 = a.年度
	AND b.社員コード = a.社員コード
LEFT OUTER JOIN
	部門_Q異動履歴_全階層順 AS c
	ON c.年度 = a.年度
	AND c.部門コード = a.部門コード
LEFT OUTER JOIN
	部門_Q名称_階層順 AS cs
	ON cs.年度 = a.年度
	AND cs.部門コード = a.部門コード
LEFT OUTER JOIN
	部所部門_T年度 AS h
	ON h.年度 = c.年度
	AND h.部門コード = c.部門コード
LEFT OUTER JOIN
	部所_T年度 AS i
	ON i.年度 = h.年度
	AND i.部所コード = h.部所コード
LEFT OUTER JOIN
	部所グループ_T年度 AS j
	ON j.年度 = i.年度
	AND j.部所グループコード = i.部所グループコード
LEFT OUTER JOIN
	職制区分_T AS d
	ON d.職制区分 = b.職制区分
LEFT OUTER JOIN
	職制_T AS e
	ON e.職制コード = b.職制コード
LEFT OUTER JOIN
	係名_T AS f
	ON f.係コード = b.係コード
LEFT OUTER JOIN
	天候コード_Q AS k
	ON k.天候コード = a.天候コード
LEFT OUTER JOIN
	休業コード_Q AS p
	ON p.休業コード = a.休業コード
LEFT OUTER JOIN
	期間コード_Q AS q
	ON q.期間コード = a.期間コード
LEFT OUTER JOIN
	事故発生時間帯_Q AS t
	ON CONVERT(varchar(5),t.時刻,108) = CONVERT(varchar(5),a.時刻,108)
LEFT OUTER JOIN
	カレンダ_T AS u
	ON u.日付 = a.日付
LEFT OUTER JOIN
	和暦_T AS uw
	ON uw.西暦 = YEAR(a.日付)
)
,

v0 AS
(
SELECT
	a0.年度
,	a0.[管理№]
,	a0.日付
,	a0.曜日
,	a0.日付表示
,	a0.年月
,	a0.年
,	a0.月
,	a0.日
,	a0.年号
,	a0.年号略称
,	a0.和暦年
,	a0.年月度
,	a0.年月表示
,	a0.時刻
,	a0.時刻表示
,	a0.時間帯コード
,	a0.時間帯
,	a0.協力会社コード
,	a0.協力会社名
,	a0.社員コード
,	a0.氏名
,	a0.カナ氏名
,	a0.年齢年
,	a0.年齢月
,	a0.年齢
,	b0.年齢割合コード
,	b0.年齢割合
,	a0.経験年
,	a0.経験月
,	a0.経験
,	c0.経験年数割合コード
,	c0.経験年数割合
,	a0.性別
,	a0.生年月日
,	a0.入社日
,	a0.退職日
,	a0.退職年度
,	a0.職制区分
,	a0.職制区分名
,	a0.職制区分名略称
,	a0.職制コード
,	a0.職制名
,	a0.職制名略称
,	a0.係コード
,	a0.係名
,	a0.係名略称
,	a0.係名省略
,	a0.部所グループコード
,	a0.部所コード
,	a0.部所グループ名
,	a0.部所名
,	a0.順序コード
,	a0.本部コード
,	a0.部コード
,	a0.所在地コード
,	a0.部門レベル
,	a0.部門コード
,	a0.県コード
,	a0.本部名
,	a0.部名
,	a0.部門名
,	a0.場所名
,	a0.県名
,	a0.部門名カナ
,	a0.部門名略称
,	a0.部門名省略
,	a0.所属
,	a0.天候コード
,	a0.天候
,	a0.災害コード
,	a0.休業コード
,	a0.休業名
,	a0.期間
,	a0.期間コード
,	a0.期間名
,	CASE ISNULL(a0.期間名,N'') WHEN N'' THEN ISNULL(a0.休業名,N'') ELSE CONVERT(nvarchar(4),ISNULL(a0.期間,0))+ISNULL(a0.期間名,N'') END AS 休業
,	a0.現場県コード
,	a0.現場市町村コード
,	a0.現場住所
,	a0.種別
,	a0.障害状況
,	a0.作業内容
,	a0.備考
,	a0.労災認定
,	a0.状況詳細
,	a0.原因詳細
,	a0.対策詳細

FROM
	v2 AS a0
LEFT OUTER JOIN
	年齢_Q AS b0
	ON b0.年齢 = a0.年齢年
LEFT OUTER JOIN
	経験年数_Q AS c0
	ON c0.経験年数 = a0.経験年
)

SELECT
*

FROM
v0 AS a000

