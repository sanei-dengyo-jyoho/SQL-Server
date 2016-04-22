with

v1 as
(
SELECT
    b1.新支払先コード
,	b1.日付
,	b1.年度
,	b1.支払先コード
,	c1.支払先名
,	c1.支払先名カナ
,	c1.支払先略称
,	c1.支払先略称カナ
,	c1.支払先種別コード
,	e1.支払先種別名
,	e1.支払先種別説明
,	c1.郵便番号
,	c1.住所
,	c1.建物名
,	c1.TEL
,	c1.FAX
,	c1.部門コード
,	c1.社員コード
,	c1.状態コード
,	c1.登録区分
,	c1.登録日時
FROM
    (
    SELECT
        a0.新支払先コード
    ,	MAX(a0.日付) AS 日付
    FROM
        支払先_T異動 as a0
    GROUP BY
        a0.新支払先コード
    )
    as a1
INNER JOIN
    支払先_T異動 as b1
    ON b1.新支払先コード = a1.新支払先コード
    AND b1.日付 = a1.日付
INNER JOIN
    支払先_T as c1
    ON c1.支払先コード = a1.新支払先コード
INNER JOIN
    支払先種別_T as e1
    ON e1.支払先種別コード = c1.支払先種別コード
WHERE
    ( isnull(c1.登録区分,-1) <= 0 )
)

SELECT
    *
FROM
    v1 as a2
