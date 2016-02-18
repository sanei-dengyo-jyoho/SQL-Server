WITH

t2 AS
(
SELECT
	年度
,	MAX(日付) AS 審査基準日
FROM
	カレンダ_T as ct2
GROUP BY
	年度
)
,

t1 AS
(
SELECT
	年度
,	会社コード
,	本社
,	順序コード
,	本部コード
,	部コード
,	課コード
,	所在地コード
,	部門レベル
,	部門コード
,	県コード
,	本部名
,	部名
,	課名
,	部門名
,	場所名
,	県名
,	部門名カナ
,	部門名略称
,	部門名省略
,	社員コード
,	氏名
,	氏
,	名
,	カナ氏名
,	カナ氏
,	カナ名
,	職制区分
,	職制コード
,	職制名
,	職制名略称
,	入社年度
,	入社日
,	退職年度
,	退職日
,	1 AS 社員
,
	CASE
		WHEN ISNULL(入社年度, 0) = 年度
		THEN 1
		ELSE 0
	END
	AS 入社
,
	CASE
		WHEN ISNULL(退職年度, 9999) = 年度
		THEN 1
		ELSE 0
	END
	AS 退職
,
	CASE
		WHEN ISNULL(退職年度, 9999) <> 年度
		THEN 1
		ELSE 0
	END
	AS 在職
,
	CASE
		WHEN 性別 = 1
		THEN 1
		ELSE 0
	END
	AS 男性
,
	CASE
		WHEN 性別 = 2
		THEN 1
		ELSE 0
	END
	AS 女性
,
	CASE
		WHEN 職制区分 = 1
		THEN 1
		ELSE 0
	END
	AS 役員
,
	CASE
		WHEN 職制区分 = 2
		THEN 1
		ELSE 0
	END
	AS 特管
,
	CASE
		WHEN 職制区分 = 3
		THEN 1
		ELSE 0
	END
	AS 専門
,
	CASE
		WHEN 職制区分 = 4
		THEN 1
		ELSE 0
	END
	AS 一般
,
	CASE
		WHEN 職制区分 = 5
		THEN 1
		ELSE 0
	END
	AS ジョインター
,
	CASE
		WHEN 職制区分 > 5
		THEN 1
		ELSE 0
	END
	AS 他
,
	CASE
		WHEN ISNULL(資格, 0) = 0
		THEN 0
		ELSE 1
	END
	AS 資格
FROM
	社員_Q異動一覧_全階層順 as xt1
WHERE
	( ISNULL(社員コード, 0) <> 0 )
)
,

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
,	t10.社員
,	t10.入社
,	t10.退職
,	t10.在職
,	t10.男性
,	t10.女性
,	t10.役員
,	t10.特管
,	t10.専門
,	t10.一般
,	t10.ジョインター
,	t10.他
,	t10.資格
FROM
	t1 AS t10
LEFT OUTER JOIN
	t2 AS t20
	ON t20.年度 = t10.年度
)

select
	*
from
	v0 as a000
