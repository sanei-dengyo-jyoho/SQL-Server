SELECT
	Name
FROM
	OPENQUERY
		(
		LINK_ADSI,
		'
		SELECT
			Name
		FROM
			''LDAP://domain.sed''
		WHERE
			objectCategory = ''computer''
		'
		)
		AS A
