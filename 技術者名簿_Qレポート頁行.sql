select
	利用者名
,	オブジェクト名
,	コントロール名
,	convert(int,キー1) as 頁
,	convert(int,キー2) as 行
,	convert(int,キー3) as [№]

from
	汎用一覧_T as a

where
	( コントロール名 = '技術者名簿_R' )
	or 	( コントロール名 = '技術者名簿一覧_R' )

