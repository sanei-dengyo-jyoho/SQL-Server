WITH

v0 AS
(
SELECT
	t10.年度
,	t20.審査基準日
,	t10.会社コード
,	t10.本社
,	t10.順序コード
,	t10.本部コード
,	t10.部コード
,	t10.課コード
,	t10.所在地コード
,	t10.部門レベル
,	t10.部門コード
,	t10.県コード
,	t10.本部名
,	t10.部名
,	t10.課名
,	t10.部門名
,	t10.場所名
,	t10.県名
,	t10.部門名カナ
,	t10.部門名略称
,	t10.部門名省略
,	t10.社員コード
,	t10.氏名
,	t10.氏
,	t10.名
,	t10.カナ氏名
,	t10.カナ氏
,	t10.カナ名
,	t10.職制区分
,	t10.職制コード
,	t10.職制名
,	t10.職制名略称
,	t10.入社年度
,	t10.入社日
,	t10.退職年度
,	t10.退職日
,	1 AS 社員
,
	CASE
		WHEN ISNULL(t10.入社年度, 0) = t10.年度
		THEN 1
		ELSE 0
	END
	AS 入社
,
	CASE
		WHEN ISNULL(t10.退職年度, 9999) = t10.年度
		THEN 1
		ELSE 0
	END
	AS 退職
,
	CASE
		WHEN ISNULL(t10.退職年度, 9999) <> t10.年度
		THEN 1
		ELSE 0
	END
	AS 在職
,
	CASE
		WHEN t10.性別 = 1
		THEN 1
		ELSE 0
	END
	AS 男性
,
	CASE
		WHEN t10.性別 = 2
		THEN 1
		ELSE 0
	END
	AS 女性
,
	CASE
		WHEN t10.職制区分 = 1
		THEN 1
		ELSE 0
	END
	AS 役員
,
	CASE
		WHEN t10.職制区分 = 2
		THEN 1
		ELSE 0
	END
	AS 特管
,
	CASE
		WHEN t10.職制区分 = 3
		THEN 1
		ELSE 0
	END
	AS 専門
,
	CASE
		WHEN t10.職制区分 = 4
		THEN 1
		ELSE 0
	END
	AS 一般
,
	CASE
		WHEN t10.職制区分 = 5
		THEN 1
		ELSE 0
	END
	AS ジョインター
,
	CASE
		WHEN t10.職制区分 > 5
		THEN 1
		ELSE 0
	END
	AS 他
,
	CASE
		WHEN ISNULL(t10.資格, 0) = 0
		THEN 0
		ELSE 1
	END
	AS 資格
FROM
	社員_Q異動一覧_全階層順 as t10
LEFT OUTER JOIN
	(
	SELECT
		t2.年度
	,	MAX(t2.日付) AS 審査基準日
	FROM
		カレンダ_T as t2
	GROUP BY
		t2.年度
	)
	AS t20
	ON t20.年度 = t10.年度
WHERE
	( ISNULL(t10.社員コード, 0) <> 0 )
)

select
	*
from
	v0 as a000
