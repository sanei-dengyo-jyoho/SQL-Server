with

v0 as
(
SELECT
    b0.システム名
,	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	b0.ページ
,	b0.頁
,	b0.行
,	b0.大分類
,	b0.中分類
,	b0.小分類
,	b0.費目
,	b0.項目名
,	b0.項目名登録
,	b0.項目名表示
,	b0.JV表示
,	b0.原価率表示
,	b0.赤
,	b0.青
,	b0.緑
FROM
    工事原価_T AS a0
CROSS JOIN
    工事原価項目_Q AS b0
)

SELECT
	*
FROM
	v0 as v000
