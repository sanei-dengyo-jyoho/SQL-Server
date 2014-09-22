WITH

con AS
(
SELECT
	SES.host_name AS [HostName]
,	CON.client_net_address AS [ClientAddress]
,	SES.login_name AS [LoginName]
,	SES.program_name AS [ProgramName]
,	EP.name AS [ConnectionTyp]
,	CON.net_transport AS [NetTransport]
,	CON.protocol_type AS [ProtocolType]
,	CONVERT(VARBINARY(9),CON.protocol_version) AS [TDSVersionHex]
,	SES.client_interface_name AS [ClientInterface]
,	CON.encrypt_option AS [IsEncryted]
,	CON.auth_scheme AS [Auth]

FROM
	sys.dm_exec_connections AS CON
LEFT OUTER JOIN
	sys.endpoints AS EP
	ON CON.endpoint_id = EP.endpoint_id
INNER JOIN
	sys.dm_exec_sessions as SES
	ON CON.session_id = SES.session_id
)

SELECT DISTINCT
	*

FROM con
