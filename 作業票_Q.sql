with

v0 as
(
select
	処理番号,
	年度,
	[管理№],
	min([設計書№]) as [設計書№]
from
	[作業票_Q設計書№] as a0
group by
	処理番号,
	年度,
	[管理№]
),

v1 as
(
select
	a1.処理番号,
	a1.年度,
	a1.[管理№],
	a1.支店コード,
	a1.支店名,
	a1.店所コード,
	a1.店所名,
	a1.[設計書№]
from
	[作業票_Q設計書№] as a1
inner join
	v0 as b1
	on b1.処理番号 = a1.処理番号
	and b1.年度 = a1.年度
	and b1.[管理№] = a1.[管理№]
	and b1.[設計書№] = a1.[設計書№]
),

v2 as
(
select
	'1' as 処理番号,
	年度,
	[管理№],
	部門コード,
	社員コード,
	受付日付,
	受付年月,
	受付時刻,
	開始日付,
	開始年月,
	予定日付,
	予定年月,
	完了日付,
	完了年月,
	完了時刻,
	作業区分,
	その他作業,
	概要,
	説明,
	理由,
	工数,
	システム名,
	業務名,
	期間区分,
	稟議書区分,
	総務承認区分,
	ネットワーク区分,
	ネットワーク名,
	'' as 原因区分,
	'' as その他原因,
	'' as [コンピュータ管理№]
from
	作業票_T業務依頼書 as a2

union all

select
	'2' as 処理番号,
	年度,
	[管理№],
	部門コード,
	社員コード,
	受付日付,
	受付年月,
	受付時刻,
	開始日付,
	開始年月,
	予定日付,
	予定年月,
	完了日付,
	完了年月,
	完了時刻,
	作業区分,
	その他作業,
	概要,
	説明,
	理由,
	工数,
	システム名,
	業務名,
	'' as 期間区分,
	'' as 稟議書区分,
	'' as 総務承認区分,
	'' as ネットワーク区分,
	'' as ネットワーク名,
	'' as 原因区分,
	'' as その他原因,
	'' as [コンピュータ管理№]
from
	作業票_T連絡票 as b2

union all

select
	'3' as 処理番号,
	年度,
	[管理№],
	部門コード,
	社員コード,
	受付日付,
	受付年月,
	受付時刻,
	開始日付,
	開始年月,
	予定日付,
	予定年月,
	完了日付,
	完了年月,
	完了時刻,
	作業区分,
	その他作業,
	概要,
	説明,
	理由,
	工数,
	システム名,
	業務名,
	'' as 期間区分,
	'' as 稟議書区分,
	'' as 総務承認区分,
	'' as ネットワーク区分,
	'' as ネットワーク名,
	原因区分,
	その他原因,
	[コンピュータ管理№]
from
	作業票_Tヘルプコール as c2
),

v3 as
(
select
	a3.処理番号,
	a3.年度,
	a3.[管理№],
	a3.部門コード,
	a3.社員コード,
	a3.受付日付,
	a3.受付年月,
	a3.受付時刻,
	a3.開始日付,
	a3.開始年月,
	a3.予定日付,
	a3.予定年月,
	a3.完了日付,
	a3.完了年月,
	a3.完了時刻,
	a3.作業区分,
	a3.その他作業,
	a3.概要,
	a3.説明,
	a3.理由,
	a3.工数,
	a3.システム名,
	a3.業務名,
	a3.期間区分,
	a3.稟議書区分,
	a3.総務承認区分,
	a3.ネットワーク区分,
	a3.ネットワーク名,
	a3.原因区分,
	a3.その他原因,
	a3.[コンピュータ管理№],
	b3.支店コード,
	b3.支店名,
	b3.店所コード,
	b3.店所名,
	b3.[設計書№]
from
	v2 as a3
left join
	v1 as b3
	on b3.処理番号 = a3.処理番号
	and b3.年度 = a3.年度
	and b3.[管理№] = a3.[管理№]
)

select
	*
from v3 as v300
