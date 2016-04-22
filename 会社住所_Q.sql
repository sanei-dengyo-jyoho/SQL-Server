with

v1 as
(
select distinct
	b1.会社コード
,	b1.所在地コード
,	b1.場所名
,	b1.場所名カナ
,	b1.場所略称
,	b1.場所略称カナ
,	b1.郵便番号
,	b1.住所
,	b1.建物名
,	b1.TEL
,	b1.FAX
,	b1.TTNET
,	b1.事業所区分
,	b1.県コード
,	b1.市町村コード
from
	(
	select
		a0.所在地コード
	from
		会社住所_T as a0
	group by
		a0.所在地コード
	)
	as a1
inner join
	会社住所_T as b1
	on b1.所在地コード = a1.所在地コード
)

select
	*
from
	v1 as v100
