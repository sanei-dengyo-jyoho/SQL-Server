with

g0 as
(
select
	ga0.システム名
,	ga0.工事番号
,	ga0.工事年度
,	ga0.工事種別
,	ga0.工事項番
,	ga0.ページ
,	ga0.頁
,	ga0.行
,	ga0.大分類
,	ga0.中分類
,	ga0.小分類
,	ga0.費目
,	ga0.項目名件数
,	ga0.項目名
,	convert(nvarchar(100),ga0.契約先1) as 契約先1
,	convert(nvarchar(100),ga0.契約先2) as 契約先2
,	ga0.契約金額
,	convert(nvarchar(100),ga0.支払先1) as 支払先1
,	convert(nvarchar(100),ga0.支払先2) as 支払先2
,	ga0.支払金額
,	ga0.支払自日付
,	ga0.支払至日付
,	ga0.支払期間
,	ga0.確定日付
,	ga0.項目名登録
,	ga0.項目名表示
,	ga0.原価率表示
,	ga0.原価率
,	ga0.赤
,	ga0.緑
,	ga0.青
,	ga0.受注金額
,	ga0.消費税率
,	ga0.消費税額
,	ga0.有効
,	ga0.JV表示
,	ga0.JV自
,	ga0.JV至
,	ga0.JV
,	ga0.請負受注金額
,	ga0.請負消費税率
,	ga0.請負消費税額
from
	支払査定_Q項目名 as ga0

union all

select
	gb0.システム名
,	gb0.工事番号
,	gb0.工事年度
,	gb0.工事種別
,	gb0.工事項番
,	gb0.ページ
,	gb0.頁
,	gb0.行
,	gb0.大分類
,	gb0.中分類
,	gb0.小分類
,	gb0.費目
,	gb0.項目名件数
,	gb0.項目名
,	convert(nvarchar(100),gb0.契約先1) as 契約先1
,	convert(nvarchar(100),gb0.契約先2) as 契約先2
,	gb0.契約金額
,	convert(nvarchar(100),gb0.支払先1) as 支払先1
,	convert(nvarchar(100),gb0.支払先2) as 支払先2
,	gb0.支払金額
,	gb0.支払自日付
,	gb0.支払至日付
,	gb0.支払期間
,	gb0.確定日付
,	gb0.項目名登録
,	gb0.項目名表示
,	gb0.原価率表示
,	gb0.原価率
,	gb0.赤
,	gb0.緑
,	gb0.青
,	gb0.受注金額
,	gb0.消費税率
,	gb0.消費税額
,	gb0.有効
,	gb0.JV表示
,	gb0.JV自
,	gb0.JV至
,	gb0.JV
,	gb0.請負受注金額
,	gb0.請負消費税率
,	gb0.請負消費税額
from
	支払査定_Q項目名_原価無し as gb0
)

select
	*
from
	g0 as g000
