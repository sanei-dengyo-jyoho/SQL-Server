select top 30
    total_elapsed_time / execution_count / 1000 as AvgElapsedTime
,	total_worker_time  / execution_count / 1000 as AvgCPUTime
,	[text] as SQLtext
,	object_name(objectid) as objectname
from
    sys.dm_exec_query_stats
cross apply
	sys.dm_exec_sql_text(sql_handle)
order by
    AvgCPUTime desc
;

--total_worker_time：コンパイル後にプランの実行で使用された CPU 時間の合計
