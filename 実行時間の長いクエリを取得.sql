select top 30
    total_elapsed_time / execution_count / 1000 as AvgElapsedTime
,	total_physical_reads / execution_count as AvgPhysicalIOCount
,	[text] as SQLtext
,	object_name(objectid) as objectname
from
    sys.dm_exec_query_stats
cross apply
	sys.dm_exec_sql_text(sql_handle)
order by
    AvgElapsedTime desc
;

--total_elapsed_time：このプランの実行完了までの経過時間の合計
--execution_count：前回のコンパイル時以降に、プランが実行された回数
--total_physical_reads：コンパイル後にこのプランの実行で行われた物理読み取りの合計数
