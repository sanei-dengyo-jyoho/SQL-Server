with

x0 as
(
select
	*
from
	コンピュータ機器一覧_Q as x00
where
	([コンピュータ分類№] >= 0)
	and ([コンピュータタイプ№] >= 0)
	and ([機器名№] >= 0)
),

q0 as
(
select distinct
	[コンピュータ管理№],
	min(ネットワーク数) as ネットワーク数
from
	コンピュータ振出_T as q00
group by
	[コンピュータ管理№]
),

q1 as
(
select distinct
	q10.[コンピュータ管理№],
	q10.機器名
from
	コンピュータ振出_T as q10
inner join
	q0 as q11
	on q11.[コンピュータ管理№] = q10.[コンピュータ管理№]
	and q11.ネットワーク数 = q10.ネットワーク数
),

v0 as
(
select
	a0.処理番号,
	a0.年度,
	a0.[管理№],
	a0.部門コード,
	b0.集計部門コード,
	b0.部門名,
	b0.部門名略称,
	b0.部門名省略,
	a0.社員コード,
	c0.氏名,
	c0.カナ氏名,
	c0.性別,
	a0.受付日付,
	a0.受付年月,
	a0.受付時刻,
	a0.開始日付,
	a0.開始年月,
	a0.予定日付,
	a0.予定年月,
	a0.完了日付,
	a0.完了年月,
	a0.完了時刻,
	case when isnull(完了日付,'')='' then 1 else 2 end as 完了区分,
	a0.作業区分,
	d0.作業内容,
	a0.その他作業,
	a0.概要,
	a0.説明,
	a0.理由,
	a0.工数,
	a0.システム名,
	a0.業務名,
	a0.期間区分,
	e0.期間,
	a0.稟議書区分,
	f0.稟議書,
	a0.総務承認区分,
	g0.総務承認,
	a0.ネットワーク区分,
	h0.ネットワーク,
	a0.ネットワーク名,
	a0.[コンピュータ管理№],
	k0.[コンピュータ分類№],
	k0.[コンピュータタイプ№],
	k0.コンピュータ分類,
	k0.コンピュータタイプ,
	0 as トラブル報告,
	a0.原因区分,
	i0.原因,
	a0.その他原因,
	a0.支店コード,
	a0.支店名,
	a0.店所コード,
	a0.店所名,
	a0.[設計書№]
from
	作業票_Q as a0
left join
	部門_T年度 as b0
	on b0.年度 = a0.年度
	and b0.部門コード = a0.部門コード
left join
	社員_T年度 as c0
	on c0.年度 = a0.年度
	and c0.社員コード = a0.社員コード
left join
	作業票_Q作業内容 as d0
	on d0.処理番号 = a0.処理番号
	and d0.作業区分 = a0.作業区分
left join
	作業票_Q期間 as e0
	on e0.処理番号 = a0.処理番号
	and e0.期間区分 = a0.期間区分
left join
	作業票_Q稟議書 as f0
	on f0.処理番号 = a0.処理番号
	and f0.稟議書区分 = a0.稟議書区分
left join
	作業票_Q総務承認 as g0
	on g0.処理番号 = a0.処理番号
	and g0.総務承認区分 = a0.総務承認区分
left join
	作業票_Qネットワーク as h0
	on h0.処理番号 = a0.処理番号
	and h0.ネットワーク区分 = a0.ネットワーク区分
left join
	作業票_Q原因 as i0
	on i0.処理番号 = a0.処理番号
	and i0.原因区分 = a0.原因区分
left join
	q1 as j0
	on j0.[コンピュータ管理№] = a0.[コンピュータ管理№]
left join
	x0 as k0
	on k0.機器名 = j0.機器名
)

select
	*
from
	v0 as t000
