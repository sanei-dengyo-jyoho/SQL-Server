with

v0 as
(
select
	a0.[受注№]
,	a0.[受注№枝番]
,	a0.訂正区分
,	a0.過去データ区分
,	a0.[訂正元受注№]
,	a0.取引先コード
,	b0.取引先名
,	b0.取引先名カナ
,	b0.取引先略称
,	b0.取引先略称カナ
,	a0.種別コード as 元種別コード
,	c0.表示コード as 種別コード
,	c0.種別
,	c0.表示コード as 受注コード
,	c0.種別 as 受注
,
	case
		isnull(b0.得意先, 0)
		when 0
		then 0
		else b0.取引先コード
	end
	as 受注得意先コード
,
	case
		isnull(b0.得意先, 0)
		when 0
		then ''
		else b0.取引先略称
	end
	as 受注得意先
,	b0.請負コード
,	d0.請負名
,	b0.得意先
,	a0.[入札レコード№]
,	a0.部門コード
,	e0.部門名
,	e0.部門名カナ
,	e0.部門名略称
,	e0.部門名省略
,	a0.社員コード
,	f0.氏名
,	f0.カナ氏名
,	f0.性別
,	a0.小口
,	a0.工事件名
,	a0.県コード
,	a0.市町村コード
,	a0.地区コード
,	g0.県名
,	g0.市区町村名
,	a0.工事場所
,	a0.工期自日付
,	a0.工期至日付
,	a0.発行日付
,	a0.発行年月
,	a0.発行年
,	a0.発行月
,	a0.発行日
,	a0.落成日付
,	a0.落成年月
,	a0.落成年
,	a0.落成月
,	a0.落成日
,	a0.受注年度
,	a0.受注年月
,	a0.受注年
,	a0.受注月
,	h0.社員コード as 担当者社員コード
,	h0.部門コード as 担当者部門コード
,	h0.氏名 as 担当者氏名
,	h0.カナ氏名 as 担当者カナ氏名
,	h0.部門名 as 担当者部門名
,	h0.部門名略称 as 担当者部門名略称
,	h0.職制名 as 担当者職制名
,	h0.職制名略称 as 担当者職制名略称
,	a0.構造主
,	a0.構造従
,	a0.延床面積
,	a0.建物用途
,	a0.受注額
,	a0.消費税率
,	a0.消費税額
,	a0.備考
,	a0.ＣＯＲＩＮＳ番号
from
	受注_T as a0
LEFT OUTER JOIN
	取引先_Q as b0
	on b0.取引先コード = a0.取引先コード
LEFT OUTER JOIN
	取引先種別_T as c0
	on c0.種別コード = a0.種別コード
LEFT OUTER JOIN
	請負_Q as d0
	on d0.請負コード = b0.請負コード
LEFT OUTER JOIN
	部門_T as e0
	on e0.部門コード = a0.部門コード
LEFT OUTER JOIN
	社員_T as f0
	on f0.社員コード = a0.社員コード
LEFT OUTER JOIN
	市区町村_Q as g0
	on g0.県コード = a0.県コード
	and g0.市町村コード = a0.市町村コード
LEFT OUTER JOIN
	受注作業担当者_Q代表 as h0
	on h0.[受注№] = a0.[受注№]
)

select
	*
from
	v0 as a1
