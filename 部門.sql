with

ve0 as
(
select top 1
	a0.会社コード
from
    UserDB.dbo.会社_T as a0
inner join
    UserDB.dbo.会社住所_T年度 as b0
    on b0.会社コード = a0.会社コード
where
	( isnull(a0.自社,0) = 1 )
	and ( isnull(a0.登録区分,-1) <= 0 )
    and ( b0.場所名 = N'本社' )
)
,

v0 as
(
select
	部門コード
,	部門名
,	部門名略称
,	会社コード
,	所在地コード
,	部門レベル
,	順序コード
,	本部コード
,	部コード
,	集計先
from
	UserDB.dbo.部門_Q階層順_簡易版 as a0
where
	( isnull(部門レベル,0) > 0 )
	and (
		会社コード =
			(
			select
				e0.会社コード
			from
				ve0 as e0
			)
		)
)

select
	*
from
 	v0 as v000
