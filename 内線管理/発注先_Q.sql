with

v0 as
(
SELECT
    新取引先コード
,   MAX(日付) AS 日付
FROM
    取引先_T異動 as a0
GROUP BY
    新取引先コード
)
,

v1 as
(
SELECT
    b1.新取引先コード
,   b1.日付
,   b1.年度
,   e1.システム名
,   e1.工事種別
,   e1.工事種別名
,   e1.工事種別コード
,   f1.発注先種別名
,   b1.取引先コード
,   c1.取引先名
,   c1.取引先名カナ
,   c1.取引先略称
,   c1.取引先略称カナ
,   c1.種別コード
,   c1.得意先
,   c1.郵便番号
,   c1.住所
,   c1.建物名
,   c1.TEL
,   c1.FAX
,   c1.部門コード
,   c1.社員コード
,   c1.状態コード
,   c1.登録区分
,   c1.登録日時
FROM
    v0 as a1
INNER JOIN
    取引先_T異動 as b1
    ON b1.新取引先コード = a1.新取引先コード
    AND b1.日付 = a1.日付
INNER JOIN
    取引先_T as c1
    ON c1.取引先コード = a1.新取引先コード
INNER JOIN
    工事種別_Q as e1
    ON e1.種別コード = c1.種別コード
left outer join
    発注先_T種別 as f1
    ON f1.取引先コード = c1.取引先コード
WHERE
    ( isnull(c1.登録区分,-1) <= 0 )
)

SELECT
    *
FROM
    v1 as a2
