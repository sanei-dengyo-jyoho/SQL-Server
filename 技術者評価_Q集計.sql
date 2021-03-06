WITH

Q3 AS
(
SELECT
	Q10.会社コード
,	Q10.年度
,	Q10.担当業種順位
,	Q10.担当業種コード
,	Q10.担当業種名
,	Q10.人数 AS 担当業種人数
,	Q20.資格順位
,	Q20.資格コード
,	Q20.資格名
,	Q20.人数 AS 資格人数
FROM
	(
	SELECT
		A1.会社コード
	,	A1.年度
	,	A1.担当業種順位
	,	A1.担当業種コード
	,	A1.担当業種名
	,	COUNT(A1.社員コード) AS 人数
	FROM
		技術者評価_Q AS A1
	GROUP BY
		A1.会社コード
	,	A1.年度
	,	A1.担当業種順位
	,	A1.担当業種コード
	,	A1.担当業種名
	)
	AS Q10
LEFT OUTER JOIN
	(
	SELECT
		A2.会社コード
	,	A2.年度
	,	A2.担当業種順位
	,	A2.担当業種コード
	,	A2.担当業種名
	,	A2.資格順位
	,	A2.資格コード
	,	A2.資格名
	,	COUNT(A2.社員コード) AS 人数
	FROM
		技術者評価_Q AS A2
	GROUP BY
		A2.会社コード
	,	A2.年度
	,	A2.担当業種順位
	,	A2.担当業種コード
	,	A2.担当業種名
	,	A2.資格順位
	,	A2.資格コード
	,	A2.資格名
	)
	AS Q20
	ON Q20.会社コード = Q10.会社コード
	AND Q20.年度 = Q10.年度
	AND Q20.担当業種コード = Q10.担当業種コード
)

SELECT
	*
FROM
	Q3 AS Q300
