WITH

v0 AS
(
SELECT
	[IPアドレス] = ec.client_net_address
,	[ポート] = MAX(ec.client_tcp_port)
,	[プログラム] = es.program_name
,	[インターフェース] = es.client_interface_name
,	[ログイン名] = es.login_name
,	[接続数] = COUNT(*)
FROM
	sys.dm_exec_sessions AS es
INNER JOIN
	sys.dm_exec_connections AS ec
	ON es.session_id = ec.session_id
GROUP BY
	ec.client_net_address
,	es.program_name
,	es.client_interface_name
,	es.login_name
)

SELECT
	*
FROM
	v0 AS v000
