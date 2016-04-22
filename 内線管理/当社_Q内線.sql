with

v0 as
(
select
    b0.年度
,	a0.会社コード
,	a0.会社名
,	a0.会社略称
,	x0.企業名
,	b0.住所
,	convert(varchar(50),isnull(t0.TEL,b0.TEL)) as TEL
,	convert(varchar(50),isnull(t0.FAX,b0.FAX)) as FAX
,	y0.期首月
,	y0.期末月
,	y0.上期首月
,	y0.上期末月
,	y0.下期首月
,	y0.下期末月
,	y0.期別加算
from
    会社_T as a0
left outer join
    会社_T企業名 as x0
    on x0.会社コード = a0.会社コード
inner join
    会社住所_T年度 as b0
    on b0.会社コード = a0.会社コード
inner join
    年度構成_T as y0
    on y0.会社コード = a0.会社コード
left outer join
    (
    select top 1
        ta0.部門コード
    ,	tb0.部門名
    ,	tb0.部門名略称
    ,	tb0.会社コード
    ,	ta0.TEL
    ,	ta0.FAX
    from
        電話番号_T as ta0
    inner join
        部門_T as tb0
        on tb0.部門コード = ta0.部門コード
    where
        ( tb0.部門名 like N'内線%' )
    order by
        tb0.部門レベル
    ,	tb0.部門コード
    )
    as t0
    on t0.会社コード = a0.会社コード
where
	( isnull(a0.自社,0) = 1 )
	and ( isnull(a0.登録区分,-1) <= 0 )
    and ( b0.場所名 = N'本社' )
)

select
	*
from
	v0 as v000
