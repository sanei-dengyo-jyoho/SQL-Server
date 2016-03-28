SELECT
	Name
,	DisplayName
,	sAMAccountName
,	AdsPath
FROM
	OPENQUERY
		(
		LINK_ADSI,
		'
		SELECT
			Name
		,	DisplayName
		,	sAMAccountName
		,	AdsPath
		FROM
			''LDAP://domain.sed''
		WHERE
			objectCategory = ''group''
		'
		)
		AS A
