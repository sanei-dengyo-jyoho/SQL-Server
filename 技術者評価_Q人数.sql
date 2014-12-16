WITH

Q0 AS
(
SELECT
	会社コード
,	年度
,	COUNT(社員コード) AS 総人数
FROM
	技術者評価_Q AS A0
GROUP BY
	会社コード
,	年度
)
,

Q1 AS
(
SELECT
	会社コード
,	年度
,	COUNT(社員コード) AS イ
FROM
	技術職員名簿_T明細 AS A1
WHERE
	(ISNULL(社員コード, 0) <> 0)
	AND (ISNULL(資格区分, 0) = 1)
GROUP BY
	会社コード
,	年度
)
,

Q2 AS
(
SELECT
	会社コード
,	年度
,	COUNT(社員コード) AS ロ
FROM
	技術職員名簿_T明細 AS A2
WHERE
	(ISNULL(社員コード, 0) <> 0)
	AND (ISNULL(資格区分, 0) = 2)
GROUP BY
	会社コード
,	年度
)
,

Q3 AS
(
SELECT
	会社コード
,	年度
,	COUNT(社員コード) AS ハ
FROM
	技術職員名簿_T明細 AS A3
WHERE
	(ISNULL(社員コード, 0) <> 0)
	AND (ISNULL(資格区分, 0) = 3)
GROUP BY
	会社コード
,	年度
)
,

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
	Q0 AS Q00
LEFT OUTER JOIN
	Q1 AS Q10
	ON Q10.会社コード = Q00.会社コード
	AND Q10.年度 = Q00.年度
LEFT OUTER JOIN
	Q2 AS Q20
	ON Q20.会社コード = Q00.会社コード
	AND Q20.年度 = Q00.年度
LEFT OUTER JOIN
	Q3 AS Q30
	ON Q30.会社コード = Q00.会社コード
	AND Q30.年度 = Q00.年度
)

SELECT
	*
FROM
	Q4 AS Q400
