with

v1 as
(
select
	b0.運転許可コード
,	b0.運転許可名
,	b0.運転許可説明
,	REPLACE((
			select TOP (100) PERCENT
				bx.車両種別名 as [data()]

			from
				運転許可コード_T車両種別 as bx

			where
				( bx.運転許可コード = b0.運転許可コード )

			order by
				bx.車両種別

			FOR XML PATH ('')
			),' ','、') as 運転許可車両種別
,	REPLACE((
			select TOP (100) PERCENT
				bx.車両種別名 as [data()]

			from
				運転許可コード_T車両種別 as bx

			where
				( bx.運転許可コード = b0.運転許可コード )

			order by
				bx.車両種別

			FOR XML PATH ('')
			),' ','、'+CHAR(13)+CHAR(10)) as 運転許可車両種別段落
,	b0.運転許可接頭語
,	b0.更新日時

from
	運転許可コード_T as b0
)

select
	*

from
	v1 as t000

