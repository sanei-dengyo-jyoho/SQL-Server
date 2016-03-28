with

v00 as
(
SELECT 会社コード, 年度, 社員コード, '01' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a01
WHERE (CONVERT(int, 業種01) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '02' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a02
WHERE (CONVERT(int, 業種02) = 1)


UNION ALL

SELECT 会社コード, 年度, 社員コード, '03' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a03
WHERE (CONVERT(int, 業種03) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '04' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a04
WHERE (CONVERT(int, 業種04) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '05' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a05
WHERE (CONVERT(int, 業種05) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '06' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a06
WHERE (CONVERT(int, 業種06) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '07' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a07
WHERE (CONVERT(int, 業種07) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '08' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a08
WHERE (CONVERT(int, 業種08) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '09' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a09
WHERE (CONVERT(int, 業種09) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '10' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a10
WHERE (CONVERT(int, 業種10) = 1)
)
,

v10 as
(
SELECT 会社コード, 年度, 社員コード, '11' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a11
WHERE (CONVERT(int, 業種11) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '12' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a12
WHERE (CONVERT(int, 業種12) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '13' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a13
WHERE (CONVERT(int, 業種13) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '14' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a14
WHERE (CONVERT(int, 業種14) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '15' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a15
WHERE (CONVERT(int, 業種15) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '16' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a16
WHERE (CONVERT(int, 業種16) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '17' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a17
WHERE (CONVERT(int, 業種17) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '18' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a18
WHERE (CONVERT(int, 業種18) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '19' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a19
WHERE (CONVERT(int, 業種19) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '20' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a20
WHERE (CONVERT(int, 業種20) = 1)
)
,

v20 as
(
SELECT 会社コード, 年度, 社員コード, '21' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a21
WHERE (CONVERT(int, 業種21) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '22' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a22
WHERE (CONVERT(int, 業種22) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '23' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a23
WHERE (CONVERT(int, 業種23) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '24' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a24
WHERE (CONVERT(int, 業種24) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '25' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a25
WHERE (CONVERT(int, 業種25) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '26' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a26
WHERE (CONVERT(int, 業種26) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '27' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a27
WHERE (CONVERT(int, 業種27) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '28' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a28
WHERE (CONVERT(int, 業種28) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '29' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a29
WHERE (CONVERT(int, 業種29) = 1)

UNION ALL

SELECT 会社コード, 年度, 社員コード, '30' AS 担当業種コード
FROM 技術職員名簿_T専任技術者 AS a30
WHERE (CONVERT(int, 業種30) = 1)
)
,

v100 as
(
SELECT
	*
FROM
	v00 AS a100

UNION ALL

SELECT
	*
FROM
	v10 AS a110

UNION ALL

SELECT
	*
FROM
	v20 AS a120
)
,

v200 as
(
SELECT
	c1.年度
,	c1.会社コード
,	c1.社員コード
,	c1.年度 as 索引年度
,	c1.会社コード as 索引会社コード
,	c1.社員コード as 索引社員コード
,	c1.担当業種コード
,	n1.担当業種
,	n1.順位
FROM
	v100 AS c1
INNER JOIN
	担当業種_T AS n1
	ON n1.担当業種コード = c1.担当業種コード
)

SELECT
	*
FROM
	v200 AS v2000
