WITH

Q4 AS
(
SELECT
	Q00.会社コード
,	Q00.年度
,	Q00.総人数
,	Q10.イ + Q20.ロ + Q30.ハ AS 実人数
,	Q10.イ
,	Q20.ロ
,	Q30.ハ
FROM
	(
	SELECT
		A0.会社コード
	,	A0.年度
	,	COUNT(A0.社員コード) AS 総人数
	FROM
		技術者評価_Q AS A0
	GROUP BY
		A0.会社コード
	,	A0.年度
	)
	AS Q00
LEFT OUTER JOIN
	(
	SELECT
		A1.会社コード
	,	A1.年度
	,	COUNT(A1.社員コード) AS イ
	FROM
		技術職員名簿_T明細 AS A1
	WHERE
		(ISNULL(A1.社員コード, 0) <> 0)
		AND (ISNULL(A1.資格区分, 0) = 1)
	GROUP BY
		A1.会社コード
	,	A1.年度
	)
	AS Q10
	ON Q10.会社コード = Q00.会社コード
	AND Q10.年度 = Q00.年度
LEFT OUTER JOIN
	(
	SELECT
		A2.会社コード
	,	A2.年度
	,	COUNT(A2.社員コード) AS ロ
	FROM
		技術職員名簿_T明細 AS A2
	WHERE
		(ISNULL(A2.社員コード, 0) <> 0)
		AND (ISNULL(A2.資格区分, 0) = 2)
	GROUP BY
		A2.会社コード
	,	A2.年度
	)
	AS Q20
	ON Q20.会社コード = Q00.会社コード
	AND Q20.年度 = Q00.年度
LEFT OUTER JOIN
	(
	SELECT
		A3.会社コード
	,	A3.年度
	,	COUNT(A3.社員コード) AS ハ
	FROM
		技術職員名簿_T明細 AS A3
	WHERE
		(ISNULL(A3.社員コード, 0) <> 0)
		AND (ISNULL(A3.資格区分, 0) = 3)
	GROUP BY
		A3.会社コード
	,	A3.年度
	)
	AS Q30
	ON Q30.会社コード = Q00.会社コード
	AND Q30.年度 = Q00.年度
)

SELECT
	*
FROM
	Q4 AS Q400
